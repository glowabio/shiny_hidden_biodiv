# Display a message that can be accepted only by clicking the
# accept button or outside the modal dialog window

# Modal dialog module UI function
modalDialogUI <- function(id, label = "Modal") {
  ns <- NS(id)
  tagList(
      actionLink(ns("show"), "Privacy Policy"
                 # a("Privacy Policy",
                 #               style = "font-size:0.8em;")
                 )
  )
}

# Modal dialog module server function
modalDialogServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      observeEvent(input$show, {
        showModal(
          modalDialog(
            title = "Privacy Policy",
            easyClose = TRUE,
            footer = modalButton("Close"),
            size = "l",
            tagList(
              
              p(em("Effective date: September 1, 2025")),
              tags$br(),
              
              p('This site provides information regarding the Privacy Policy and Legal Notes in 
                compliance with § 6 TDG ("Telemediengesetz").'),
              
              p('The Leibniz Institute of Freshwater Ecology and Inland Fisheries (IGB) in the 
                Forschungsverbund Berlin e.V., also named "us", "we", or "our" in this Privacy Policy, 
                operates the ',
                tags$a(href="https://hiddenbiodiversity.org/", target="_blank", "hiddenbiodiversity.org"),
                " website."
              ),
              
              p("We want to inform you of our policies regarding the use of personal data when you 
                visit our website and the choices you have associated with that data. All data on 
                this website are processed based on the current laws and regulations (General 
                Data Protection Regulation; GDPR)."),
              
              p('By using the website, you agree to the collection and use of information in 
                accordance with this policy.'),
              
              tags$strong("Information collection and use"),
              p("We do not employ cookies or collect any personal information of visitors. 
                 Any database entry submitted by a user is assigned a random identifier such that
                 each database entry remains unique, along with the date and time of the entry."),
              
              tags$strong("Links To Other Sites"),
              p("Our website may contain links to other sites that are not operated by us. If you 
                 click on a third party link, you will be directed to that third party's site. We 
                 strongly advise you to review the Privacy Policy of every site you visit. We have 
                 no control over and assume no responsibility for the content, privacy policies or 
                 practices of any third party sites or services."),
              
              tags$strong("Copyright"),
              p("This website contains links to material protected by copyright, trademark, and 
                 other proprietary rights and laws. By using our website, you acknowledge that 
                 the content and information – including but not limited to – texts, sounds, 
                 photographs, videos, graphics or other material, contained in this website, may 
                 be protected by copyrights, trademarks, service marks, patents or other proprietary 
                 rights and laws. Material and/or links on this website do not constitute legal 
                 advice, political advice, and/or other advice. Permission is granted to use 
                 materials contained on this website, in part or in full, for personal and 
                 educational purposes, but not commercial purposes, provided that you keep 
                 all copyright and other proprietary notices intact and provided that full 
                 credit is given to our website and the respective copyright, trademark, or 
                 other proprietary rights holder. You may not modify, copy, reproduce, republish, 
                 upload, post, transmit, or distribute in any way content available through this 
                 website, with the exception of public documents such as treaties and conventions."
              ),
              
              tags$strong("Possible errors"),
              p('While we strive for accuracy, we make no guarantees, warranties and / or other 
                 representations about the suitability, reliability, availability, timeliness, or 
                 accuracy of this website for any purpose. The website and information contained 
                 here are provided "as is" without warranty of any kind. We do not represent or 
                 warrant that this website will be uninterrupted or error-free, that defects will 
                 be corrected, or that the webpages or the server that makes it available, are 
                 free of viruses or other harmful components. Changes and / or improvements may 
                 be made to this website at any time.'),
              
              tags$strong("Changes to this Privacy Policy and the Legal Notes"),
              p('We may update our Privacy Policy from time to time. We will notify you of any 
                 changes by posting the new Privacy Policy on this page. We will let you know via 
                 a prominent notice on our website, prior to the change becoming effective and 
                 update the "effective date" at the top of this Privacy Policy. You are advised 
                 to review this Privacy Policy periodically for any changes. Changes to this 
                 Privacy Policy are effective when they are posted on this page.'),
              
              tags$strong("Your rights"),
              p("You have the right to get information, ask for correction or request deletion of 
                 any of your personal data which we might have stored any time. You can contact 
                 us if you have questions concerning your personal data and our data privacy 
                 policy via the person and contact details named below."),
              
              tags$strong("Contact us"),
              tags$p(
                tagList(
                  "If you have any questions about this Privacy Policy and the Legal Notes, please contact us:",
                  tags$br(), tags$br(),
                  "Dr. Sami Domisch", tags$br(),
                  "Leibniz Institute of Freshwater Ecology and Inland Fisheries", tags$br(),
                  "in the Forschungsverbund Berlin e.V.", tags$br(),
                  "Department of Community and Ecosystem Ecology", tags$br(),
                  "Justus-von-Liebig-Str. 7", tags$br(),
                  "D-12489 Berlin", tags$br(),
                  "Germany", tags$br(), tags$br(),
                  "E-mail: ", tags$a(href = "mailto:sami.domisch@igb-berlin.de", "sami.domisch@igb-berlin.de"), tags$br(),
                  "Phone: +49 (0) 30 6392 4079"
                )
              )
            )
          )
        )
      })
      
    }
  )
}





