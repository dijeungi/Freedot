package com.example.be.domain.contact.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class ContactDTO {

  private Long id;
  private String name;
  private String phoneNumber;
  private String nickname;
  private String address;
  private String email;
}
