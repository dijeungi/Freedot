package com.example.be;

import java.util.List;

public interface ContactService {

  List<ContactDTO> getAllContacts();

  ContactDTO getContact(Long id);

  ContactDTO createContact(ContactDTO contactDTO);

  ContactDTO updateContact(Long id, ContactDTO contactDTO);

  void deleteContact(Long id);

  default Contact toEntity(ContactDTO contactDTO) {
    return Contact.builder()
        .id(contactDTO.getId())
        .name(contactDTO.getName())
        .phoneNumber(contactDTO.getPhoneNumber())
        .nickname(contactDTO.getNickname())
        .email(contactDTO.getEmail())
        .address(contactDTO.getAddress())
        .build();
  }

  default ContactDTO toDTO(Contact contact) {
    return ContactDTO.builder()
        .id(contact.getId())
        .name(contact.getName())
        .phoneNumber(contact.getPhoneNumber())
        .nickname(contact.getNickname())
        .email(contact.getEmail())
        .address(contact.getAddress())
        .build();
  }


}
