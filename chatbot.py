import torch
import random
import os
import logging
import openai
import re

# KoElectra
from classifier import KoELECTRAforSequenceClassfication
from transformers import ElectraModel, ElectraConfig, ElectraTokenizer
#from kobert_transformers import get_kobert_model

# warning 출력 안되게
logging.getLogger("transformers").setLevel(logging.ERROR)
import warnings
warnings.filterwarnings("ignore", message=".*resume_download.*", category=FutureWarning)

os.environ["CUDA_DEVICE_ORDER"]="PCI_BUS_ID"
os.environ["CUDA_VISIBLE_DEVICES"]="0"

def load_wellness_answer(category_path, answer_path):
    c_f = open(category_path, 'r')
    a_f = open(answer_path, 'r')

    category_lines = c_f.readlines()
    answer_lines = a_f.readlines()

    category = {}
    answer = {}
    for line_num, line_data in enumerate(category_lines):
        data = line_data.split('    ')
        if len(data) != 2:
            print(f"Error in category file at line {line_num}: {line_data}")
        category[data[1][:-1]] = data[0]

    for line_num, line_data in enumerate(answer_lines):
        data = line_data.split('    ')
        keys = answer.keys()
        if len(data) != 2:
            print(f"Error in answer file at line {line_num}: {line_data}")
        if (data[0] in keys):
            answer[data[0]] += [data[1][:-1]]
        else:
            answer[data[0]] = [data[1][:-1]]
    return category, answer


def load_model(checkpoint_path):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model_config = ElectraConfig.from_pretrained("monologg/koelectra-base-v3-discriminator")

    model = KoELECTRAforSequenceClassfication(model_config, num_labels=432, hidden_dropout_prob=0.1)
    checkpoint = torch.load(checkpoint_path, map_location=device)
    model.load_state_dict(checkpoint['model_state_dict'])
    model.to(device)
    model.eval()

    tokenizer = ElectraTokenizer.from_pretrained("monologg/koelectra-base-v3-discriminator")
    return model, tokenizer, device

def preprocess_input(tokenizer, sent, device, max_seq_len=512):
    index_of_words = tokenizer.encode(sent)
    token_type_ids = [0] * len(index_of_words)
    attention_mask = [1] * len(index_of_words)
    padding_length = max_seq_len - len(index_of_words)
    index_of_words += [0] * padding_length
    token_type_ids += [0] * padding_length
    attention_mask += [0] * padding_length

    data = {
        'input_ids': torch.tensor([index_of_words]).to(device),
        'token_type_ids': torch.tensor([token_type_ids]).to(device),
        'attention_mask': torch.tensor([attention_mask]).to(device),
        }
    return data

def get_answer(category, answer, output, input_sentence):
    softmax_logit = torch.softmax(output[0], dim=-1).squeeze()
    max_index = torch.argmax(softmax_logit).item()
    max_index_value = softmax_logit[torch.argmax(softmax_logit)].item()

    threshold = 0.35

    selected_categories = []
    for i, value in enumerate(softmax_logit):
        if value > threshold:
            if str(i) in category:
                selected_categories.append(category[str(i)])
                print(f"카테고리 분류 -> [ {category[str(i)]} ]")
    if not selected_categories:
        return "선택된 카테고리가 없습니다. 다시 입력해주세요", None, max_index_value, []

    all_answers = []
    for category_name in selected_categories:
        if category_name in answer:
            all_answers.extend(answer[category_name])

    if not all_answers:
        return "선택된 카테고리에 대한 답변이 없습니다.", None, max_index_value, []

    selected_answer = random.choice(all_answers)

    return selected_answer, selected_categories, max_index_value, all_answers

"""
기룡이의 말투를 정해주세요

1. "저는 심리상담을 전문으로 하는 AI 기룡이 입니다."
    - 매우 공식적이고 예의바른 말투 / 전문성과 신뢰감을 주는 인상
2. "나는 심리 상담 챗봇 AI 기룡이야!"
    - 친근하고 편안한 말투로 반말 체를 사용 / 좀 더 친구같고 가벼운 느낌
3. "저는 심리 상담을 해주는 AI 기룡이에요."
    - 예의바르면서도 부드럽고 온화한 말투 /  상대방을 존중하지만 거리감은 크지 않음
"""

def gpt(input_sentence, selected_categories): # 지금은 chatbot_type 삭제
    openai.api_key = "sk-proj-zOVzKRhoYruJJhEkU24DT3BlbkFJXdYQxKnCQHXFBpfxbc2q"
    MODEL = "gpt-3.5-turbo"
    #MODEL = "gpt-4-turbo"

    # 감정 분류 모델에서 예측한 카테고리
    predicted_category = selected_categories

    # 입력받은 사용자 문장
    user_input = input_sentence

    # 프롬프트 설정
    prompts = {
        "formal": f"예측한 카테고리는 '{predicted_category}'입니다. 사용자 문장과 예측한 카테고리를 기반으로 매우 공식적인 말투(~다 로 끝나는)로 심리 상담 챗봇에 쓸 답변을 생성해주세요. 답변은 100자 이하로 만들어주세요.",
        "casual": f"예측한 카테고리는 '{predicted_category}'입니다. 사용자 문장과 예측한 카테고리를 기반으로 도움과 격려가 되는 친근하고 편안한 말투로 반말 체를 사용하여 심리 상담 챗봇에 쓸 답변을 생성해주세요. 답변은 100자 이하로 만들어주세요.",
        "polite" : f"The predicted category is '{predicted_category}. Based on your sentences and predicted categories, please create answers for your psychological counseling chatbot with a friendliness, polite tone that is helpful and encouraging. Please make your answers up to 200 characters",

        # "polite": f"예측한 카테고리는 '{predicted_category}'입니다. 사용자 문장과 예측한 카테고리를 기반으로 도움과 격려가 되는 예의바르면서도 부드럽고 온화한 말투로 심리 상담 챗봇에 쓸 답변을 생성해주세요. 답변은 100자 이하로 만들어주세요.",
        "default": f"예측한 카테고리는 '{predicted_category}'입니다. 사용자 문장과 예측한 카테고리를 기반으로 도움과 격려가 되는 부드러운 문장으로 심리 상담 챗봇에 쓸 답변을 생성해주세요. 답변은 100자 이하로 만들어주세요."
    }

    # 임시로 랜덤 타입
   # chatbot_type = random.randint(1, 3)
    chatbot_type = 3
    match chatbot_type:
        case 1:
            prompt = prompts.get(chatbot_type, prompts["formal"])    # 공식적이고 예의바른 말투
            print('<사무적인 말투>')
        case 2:
            prompt = prompts.get(chatbot_type, prompts["casual"])    # 친근하고 편안한 말투로 반말 체
            print('<친근한 반말투>')
        case 3:
            prompt = prompts.get(chatbot_type, prompts["polite"])    # 예의바르면서도 부드럽고 온화한 말투
            print('<부드러운 말투>')
        case _:
            prompt = prompts.get(chatbot_type, prompts["default"])   # 기본


    messages = [
        {"role": "system", "content": prompt},
        {"role": "user", "content": user_input}
    ]

    response = openai.ChatCompletion.create(
        model=MODEL,
        messages=messages,
        temperature=0.9,
        max_tokens=200,
        n=1,
    )

    # 응답 처리
    original_response = response.choices[0].message.content
    if not original_response.endswith('.'):
        last_sentence = re.split(r'[.!?]', original_response)[-1].strip()
        if last_sentence:
            final_response = original_response + '.'
        else:
            final_response = original_response
    else:
        final_response = original_response

    return final_response


def chat(message):
    root_path = "."
    answer_path = f"{root_path}/data/new_answer.txt"
    category_path = f"{root_path}/data/new_category_v2.txt"
    checkpoint_path = f"{root_path}/checkpoint/new_electra_v5.pth"

    category, answer = load_wellness_answer(category_path, answer_path)
    model, tokenizer, device = load_model(checkpoint_path)

    sent = str(message)

    data = preprocess_input(tokenizer, sent, device, 512)
    output = model(**data)
    answer, category, max_index_value, all_answers = get_answer(category, answer, output, sent)

    chatbot_answer = gpt(sent,category)

    # 24시간 전화 상담
    # 자살예방상담전화 109
    # 청소년전화 1388
    # 정신건강상담전화 1577-0199
    # 한국생명의전화 1588-9191
    
    print(f"\n🤖 챗봇 : {chatbot_answer}")
    print()

    return chatbot_answer, category