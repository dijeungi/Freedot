package com.example.be;

import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/contact")
public class ContactController {

  private final ContactService contactService;

  @GetMapping
  public ResponseEntity<List<ContactDTO>> getAllContacts() {
    return ResponseEntity.ok(contactService.getAllContacts());
  }

  @GetMapping("/{id}")
  public ResponseEntity<ContactDTO> details(@PathVariable Long id) {
    return ResponseEntity.ok(contactService.getContact(id));
  }

  @PostMapping
  public ResponseEntity<ContactDTO> createContact(@RequestBody ContactDTO contactDTO) {
    ContactDTO createdContact = contactService.createContact(contactDTO);
    return ResponseEntity.status(HttpStatus.CREATED).body(createdContact);
  }

  @PutMapping("/{id}")
  public ResponseEntity<ContactDTO> updateContact(@PathVariable Long id, @RequestBody ContactDTO contactDTO) {
    ContactDTO updatedContact = contactService.updateContact(id, contactDTO);
    return ResponseEntity.status(HttpStatus.OK).body(updatedContact);
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deleteContact(@PathVariable Long id) {
    contactService.deleteContact(id);
    return ResponseEntity.status(HttpStatus.OK).build();
  }

}
