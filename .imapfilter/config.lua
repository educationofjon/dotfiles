function main()
   -- One of the work mailservers is slow.
   -- The time in seconds for the program to wait for a mail server's response (default 60)
   options.timeout = 120

   -- According to the IMAP specification, when trying to write a message to a non-existent mailbox, the server must send a hint to the client, whether it should create the mailbox and try again or not. However some IMAP servers don't follow the specification and don't send the correct response code to the client. By enabling this option the client tries to create the mailbox, despite of the server's response.
   options.create = true

   -- By enabling this option new mailboxes that were automatically created, get also subscribed; they are set active in order for IMAP clients to recognize them
   options.subscribe = true

   -- Normally, messages are marked for deletion and are actually deleted when the mailbox is closed. When this option is enabled, messages are expunged immediately after being marked deleted.
   options.expunge = true

   cmd = io.popen('pass mail/rojikkushisutemu@gmail.com', 'r')
   out = cmd:read('*a')
   pass = string.gsub(out, '[\n\r]+', '')

   local personal = IMAP {
      server = "imap.gmail.com",
      username = "rojikkushisutemu@gmail.com",
      password = pass,
      ssl = "tls1"
   }

   mails = personal['INBOX']:select_all()

   -- move mailing lists from INBOX to correct folders
   move_mailing_lists(personal, mails)

   -- move spam to spam folder
   move_spam(personal, mails, "[Gmail]/Spam")

   -- delete old spam
   delete_older(personal, "[Gmail]/Spam", 30)

   -- delete old sent
   delete_older(personal, "[Gmail]/Sent Mail", 120)

end

function move_mailing_lists(account, mails)
   -- boletas
   delete_older(account, "boletas", 365)
   move_if_from_contains(account, mails, "amazon.com", "boletas")
   move_if_from_contains(account, mails, "purse.io", "boletas")

   -- viajes
   delete_older(account, "viajes", 365)
   move_if_from_contains(account, mails, "renfe", "viajes")
   move_if_from_contains(account, mails, "booking.com", "viajes")

   -- links
   delete_older(account, "links", 30)
   move_if_to_contains(account, mails, "links-programacion@googlegroups.com", "links")

   -- github
   delete_older(account, "github", 30)
   move_if_to_contains(account, mails, "github.com", "github")

   -- libros
   delete_older(account, "libros", 30)
   move_if_from_contains(account, mails, 'support@pragprog.com', "libros")
   move_if_from_contains(account, mails, 'cma@bitemyapp.com', "libros")
   move_if_from_contains(account, mails, 'hello@leanpub.com', "libros")
   move_if_from_contains(account, mails, 'oreilly@post.oreilly.com', "libros")
   move_if_from_contains(account, mails, 'pragmaticbookshelf.com', "libros")
   move_if_from_contains(account, mails, 'manning.com', "libros")

   -- elearning
   delete_older(account, "elearning", 14)
   move_if_from_contains(account, mails, 'courseupdates.edx.org', "elearning")
   move_if_from_contains(account, mails, 'news@edx.org', "elearning")
   move_if_from_contains(account, mails, "noreply@coursera.org", "elearning")

   -- explore
   delete_older(account, "explore", 14)
   move_if_from_contains(account, mails, "noreply@github.com", "explore")
   move_if_from_contains(account, mails, "noreply@medium.com", "explore")
   move_if_from_contains(account, mails, "hello@thinkful.com", "explore")
   move_if_from_contains(account, mails, "weekly@changelog.com", "explore")

   --infoq
   delete_older(account, "ocaml", 14)
   move_if_from_contains(account, mails, "mailer.infoq.com", "infoq")

   -- llvm
   delete_older(account, "llvm", 14)
   move_if_from_contains(account, mails, "list@llvmweekly.org", "llvm")

   -- python
   delete_older(account, "python", 14)
   move_if_from_contains(account, mails, "admin@pycoders.com", "python")
   move_if_from_contains(account, mails, "rahul@pythonweekly.com", "python")

   -- pony
   delete_older(account, "pony", 14)
   move_if_to_contains(account, mails, "pony.groups.io", "pony")

   -- clojure
   delete_older(account, "clojure", 14)
   move_if_to_contains(account, mails, "onyx-user@googlegroups.com", "clojure")
   move_if_to_contains(account, mails, "clojure@googlegroups.com", "clojure")
   move_if_from_contains(account, mails, "eric@lispcast.com", "clojure")

  -- erlang
   delete_older(account, "erlang", 14)
   move_if_to_contains(account, mails, "lisp-flavoured-erlang@googlegroups.com", "erlang")
   move_if_to_contains(account, mails, "erlang-questions@erlang.org", "erlang")
   move_if_to_contains(account, mails, "info@verne.mq", "erlang")

   -- rust
   delete_older(account, "rust", 14)
   move_if_from_contains(account, mails, 'this-week-in-rust@webstream.io', "rust")

end

function move_spam(account, mails, spam_mailbox)
   spam_from = {}
   for n, mail_from in ipairs(spam_from) do
      move_if_from_contains(account, mails, mail_from, spam_mailbox)
   end

end

-- helper functions
function move_if_subject_contains(account, mails, subject, mailbox)
    filtered = mails:contain_subject(subject)
    filtered:move_messages(account[mailbox]);
end

function move_if_to_contains(account, mails, to, mailbox)
    filtered = mails:contain_to(to)
    filtered:move_messages(account[mailbox]);
end

function move_if_from_contains(account, mails, from, mailbox)
    filtered = mails:contain_from(from)
    filtered:move_messages(account[mailbox]);
end

function delete_mail_from(account, mails, from)
    filtered = mails:contain_from(from)
    filtered:delete_messages()
end

function delete_mail_if_subject_contains(account, mails, subject)
    filtered = mails:contain_subject(subject)
    filtered:delete_messages()
end

function delete_older(account, mailbox, age)
    filtered = account[mailbox]:is_older(age)
    filtered:delete_messages()
end

main()
