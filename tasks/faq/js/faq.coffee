###
Copyright (c) 2013, Regents of the University of California
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###
submitFAQForm = (event) ->
  event.preventDefault()

  #form = $(event.target)
  #errorP = form.find('#error')

  # grab all the data in the form and pack it into JSON
  form_data = form2js('formFAQ', '.', true)

  alert(JSON.stringify(form_data, undefined, 2)); # show what was done just because

  TabCAT.Task.logEvent({}, event, {testing : 'foo'})

  TabCAT.Task.logEvent({}, event, {form:form_data})


  return


# fanciness to make comments required when "other" is checked
onOtherQualityIssuesClicked = (event) ->
  $comments = $('#administrationNotesForm').find('textarea[name=comments]')
  $commentsFieldset = $comments.parents('fieldset')
  if $(event.target).is(':checked')
    $comments.attr('required', 'required')
    $commentsFieldset.addClass('required')
  else
    $comments.removeAttr('required')
    $commentsFieldset.removeClass('required')
  return


setUpForm = ->
  $form = $('#formFAQ')
  $form.on('submit', submitFAQForm)
  $form.find('button').removeAttr('disabled')

  # $form.find('input[name=qualityIssues][value=other]')
  #   .on('click', onOtherQualityIssuesClicked)
  # workaround to make labels clickable in iOS Safari 5
  $form.find('label').attr('onclick', '')

  #alert("done setup")

@initFAQPage = ->

  #TabCAT.UI.requireUserAndEncounter()
  TabCAT.Task.start(trackViewport: false)

  $(setUpForm)

  TabCAT.DB.startSpilledDocSync()
