package com.example.be;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
public class ContactServiceImpl implements ContactService {

  private final ContactRepository contactRepository;

  @Transactional(readOnly = true)
  @Override
  public List<ContactDTO> getAllContacts() {
    log.info("getAllContacts 시작...");

    List<Contact> contacts = contactRepository.findAll();
    return contacts.stream()
        .map(this::toDTO)
        .toList();
  }

  @Transactional(readOnly = true)
  @Override
  public ContactDTO getContact(Long id) {
    log.info("getContact 시작...");
    Contact contact = contactRepository.findById(id)
        .orElseThrow(() -> new RuntimeException("Contact not found with id: " + id));
    return toDTO(contact);
  }

  @Override
  public ContactDTO createContact(ContactDTO contactDTO) {
    log.info("createdContact 시작...");

    Contact contact = toEntity(contactDTO);
    Contact createdContact = contactRepository.save(contact);
    return toDTO(createdContact);
  }

  @Override
  public ContactDTO updateContact(Long id, ContactDTO contactDTO) {
    log.info("updateContact 시작...");

    Contact existingContact = contactRepository.findById(id)
        .orElseThrow(() -> new RuntimeException("Contact not found with id: " + id));

    existingContact.setName(contactDTO.getName());
    existingContact.setPhoneNumber(contactDTO.getPhoneNumber());
    existingContact.setEmail(contactDTO.getEmail());
    existingContact.setAddress(contactDTO.getAddress());
    existingContact.setNickname(contactDTO.getNickname());

    Contact updatedContact = contactRepository.save(existingContact);
    return toDTO(updatedContact);
  }

  @Override
  public void deleteContact(Long id) {
    log.info("deleteContact 시작...");

    if (!contactRepository.existsById(id)) {
      throw new RuntimeException("Contact not found with id: " + id);
    }

    contactRepository.deleteById(id);
  }
}
