class Email {
  final String sender, time, subject, message, avatar, recipients;
  final bool hasAttachment, containsPictures, isRead;
  const Email(this.sender, this.time, this.subject, this.message, this.avatar,
      this.recipients, this.hasAttachment, this.containsPictures, this.isRead);
}
