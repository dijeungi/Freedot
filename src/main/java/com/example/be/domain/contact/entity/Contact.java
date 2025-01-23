package com.example.be.domain.contact.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
@Table(name = "contact")
public class Contact {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(name = "name")
  @NotNull
  private String name;

  @Column(name = "phone_number")
  @NotNull
  @jakarta.validation.constraints.Pattern(
      regexp = "^010-\\d{4}-\\d{4}$",
      message = "전화번호는 '010-xxxx-xxxx' 형식이어야 합니다."
  )
  private String phoneNumber;

  @Column(name = "nickname", nullable = true)
  private String nickname;

  @Column(name = "email", nullable = true)
  private String email;

  @Column(name = "address", nullable = true)
  private String address;

}
