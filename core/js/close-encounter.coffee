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
submitAdministrationNotesForm = (event) ->
  event.preventDefault()

  form = $(event.target)
  errorP = form.find('#error')

  notes = {}

  goodForResearch = form.find('input[name=goodForResearch]:checked').val()
  if goodForResearch?
    notes.goodForResearch = goodForResearch is 'yes'
  else
    errorP.text(
      'Please specify whether this encounter was useful for research')
    return

  qualityIssues = (
    $(cb).val() for cb in form.find('input[name=qualityIssues]:checked'))
  if qualityIssues.length > 0
    qualityIssues.sort()
    notes.qualityIssues = qualityIssues

  comments = form.find('textarea[name=comments]').val().trim()
  if comments
    notes.comments = comments
  else
    if 'other' in qualityIssues
      errorP.text('Please describe the other data quality issue(s)')
      return

  # success! close encounter and redirect
  errorP.text('')

  hash = {}
  patientCode = TabCAT.Encounter.getPatientCode()
  if patientCode?
    hash.closedEncounterWith = patientCode

  TabCAT.Encounter.close(administrationNotes: notes).always(->
    window.location = (
      'create-encounter.html' + TabCAT.UI.encodeHashJSON(hash))
  )

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
  $form = $('#administrationNotesForm')
  $form.on('submit', submitAdministrationNotesForm)
  $form.find('button').removeAttr('disabled')

  $form.find('input[name=qualityIssues][value=other]')
    .on('click', onOtherQualityIssuesClicked)
  # workaround to make labels clickable in iOS Safari 5
  $form.find('label').attr('onclick', '')


@initCloseEncounterPage = ->
  TabCAT.UI.requireUserAndEncounter()

  $(TabCAT.UI.updateStatusBar)

  $(setUpForm)

  TabCAT.DB.startSpilledDocSync()
