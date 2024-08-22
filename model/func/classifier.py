import torch
import torch.nn as nn
from torch.nn import CrossEntropyLoss, MSELoss
import torch.nn.functional as F
from transformers import ElectraModel, ElectraConfig, ElectraTokenizer

class KoELECTRAforSequenceClassfication(nn.Module):
    def __init__(self, config, num_labels=317, hidden_dropout_prob=0.1):  # 432
        super().__init__()
        self.num_labels = num_labels
        self.electra = ElectraModel(config)
        self.dropout = nn.Dropout(hidden_dropout_prob)
        self.classifier = nn.Linear(config.hidden_size, num_labels)
        self.additional_layer_1 = nn.Linear(config.hidden_size, config.hidden_size * 4)
        self.additional_layer_2 = nn.Linear(config.hidden_size * 4, config.hidden_size)
        self.pooler = nn.Linear(config.hidden_size, config.hidden_size)

    def forward(self, input_ids, attention_mask, token_type_ids, labels=None):
        outputs = self.electra(
            input_ids,
            attention_mask=attention_mask,
            token_type_ids=token_type_ids,
            output_hidden_states=True,
        )

        pooled_output = outputs.last_hidden_state[:, 0, :]  # 변경
        pooled_output = self.pooler(pooled_output)  # 변경

        pooled_output = self.dropout(pooled_output)
        pooled_output = self.additional_layer_1(pooled_output)
        pooled_output = nn.functional.relu(pooled_output)
        pooled_output = self.additional_layer_2(pooled_output)

        logits = self.classifier(pooled_output)

        outputs = (logits,) + outputs[2:]

        if labels is not None:
            loss_fct = nn.CrossEntropyLoss()
            loss = loss_fct(logits.view(-1, self.num_labels), labels.view(-1))
            outputs = (loss,) + outputs

        return outputs

def koelectra_input(tokenizer, str, device=None, max_seq_len=512):
    encoding = tokenizer.encode_plus(
        str,
        max_length=max_seq_len,
        pad_to_max_length=True,
        truncation=True,
        return_tensors="pt"
    )

    input_ids = encoding["input_ids"].to(device)
    token_type_ids = encoding["token_type_ids"].to(device)
    attention_mask = encoding["attention_mask"].to(device)

    data = {
        'input_ids': input_ids,
        'token_type_ids': token_type_ids,
        'attention_mask': attention_mask,
    }

    return data
