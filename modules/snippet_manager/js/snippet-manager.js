/**
 * @file
 * Snippet manager behaviors.
 */

(function ($, Drupal) {

  'use strict';

  Drupal.behaviors.snippetManager = {
    attach: function (context, settings) {

      /* global CodeMirror */
      if (typeof CodeMirror == 'undefined') {
        alert(Drupal.t('CodeMirror library is not loaded!'));
        return;
      }

      // -- HTML source page.
      var $soureTextArea = $('.snippet-html-source:visible');
      if ($soureTextArea[0]) {
        CodeMirror.fromTextArea($soureTextArea[0], {
          mode: 'text/html',
          lineNumbers: true,
          readOnly: true,
          foldGutter: true,
          fullscreen: true,
          gutters: ['CodeMirror-linenumbers', 'CodeMirror-foldgutter']
        });
        return;
      }

      // -- Edit snippet page.
      var $textArea = $('.snippet-code-textarea:visible');
      if (!$textArea[0]) {
        return;
      }

      function getModes() {
        var modes = {};
        var modesEncoded = $.cookie('snippetModes');
        if (modesEncoded) {
          modes = JSON.parse(modesEncoded);
        }
        return modes;
      }

      function setFullScreen(state) {
        editor.setOption('fullScreen', state);
        $('#sm-button-enlarge').toggle(!state);
        $('#sm-button-shrink').toggle(state);
      }

      function createList(type) {
        var list = '<' + type + '>\n';
        doc.getSelection().split('\n').forEach(function (value) {
          list += '  <li>' + value + '</li>\n';
        });
        list += '</' + type + '>\n';
        doc.replaceSelection(list, doc.getCursor());
      }

      function createToolbar() {
        var $editor = $('.CodeMirror');

        $('<div id="snippet-manager-buttons"></div>')
          .prependTo($editor)
          .load(settings.snippetManager.buttonsPath);

        var $toolbar = $('<div class="snippet-manager-toolbar"></div>')
          .prependTo($editor);

        var buttons = [
          'bold',
          'italic',
          'underline',
          'strikethrough',
          'list-numbered',
          'list-bullet',
          'undo',
          'redo',
          'clear-formatting',
          'enlarge',
          'shrink'
        ];

        buttons.forEach(function (button, title) {
          // @TODO: Add title attribute.
          $('<svg id="sm-button-' + button + '" class="sm-button"><use xlink:href="#icon-' + button + '"></use></svg>')
            .appendTo($toolbar);
        });

        $('<select id="sm-mode"/>')
          .append('<option value="twig">Twig</option>')
          .append('<option value="xml">HTML / XML</option>')
          .append('<option value="javascript">JavaScript</option>')
          .append('<option value="css">CSS</option>')
          .val(mode)
          .change(function () {
            var value = $(this).val();
            editor.setOption('mode', value);
            // Save the value to cookie.
            var modes = getModes();
            modes[settings.snippetManager.snippetId] = value;
            $.cookie('snippetModes', JSON.stringify(modes));

          })
          .appendTo($toolbar);

        $('#sm-button-bold').click(function () {
          doc.replaceSelection('<strong>' + doc.getSelection() + '</strong>', doc.getCursor());
        });

        $('#sm-button-italic').click(function () {
          doc.replaceSelection('<em>' + doc.getSelection() + '</em>', doc.getCursor());
        });

        $('#sm-button-underline').click(function () {
          doc.replaceSelection('<span class="text-decoration: underline">' + doc.getSelection() + '</span>', doc.getCursor());
        });

        $('#sm-button-strikethrough').click(function () {
          doc.replaceSelection('<del>' + doc.getSelection() + '</del>', doc.getCursor());
        });

        $('#sm-button-list-numbered').click(function () {
          createList('ul');
        });

        $('#sm-button-list-bullet').click(function () {
          createList('ol');
        });

        $('#sm-button-undo').click(function () {
          doc.undo();
        });

        $('#sm-button-redo').click(function () {
          doc.redo();
        });

        $('#sm-button-clear-formatting').click(function () {
          doc.replaceSelection($('<div>' + doc.getSelection() + '</div>').text(), doc.getCursor());
        });

        $('#sm-button-enlarge').click(function () {
          setFullScreen(true);
        });

        $('#sm-button-shrink').hide().click(function () {
          setFullScreen(false);
        });

      }

      // Bubble error class.
      if ($textArea.hasClass('error')) {
        $textArea.parent().addClass('snippet-error');
      }

      // Remove "required" attribute because the textarea is no focusable.
      $textArea.removeAttr('required');

      var mode = getModes()[settings.snippetManager.snippetId] || settings.snippetManager.codeMirror.mode;

      var editor = CodeMirror.fromTextArea($textArea[0], {
        lineNumbers: true,
        mode: mode,
        theme: settings.snippetManager.codeMirror.theme,
        extraKeys: {
          F11: function (editor) {
            setFullScreen(!editor.getOption('fullScreen'));
          },
          Esc: function (editor) {
            setFullScreen(false);
          }
        }
      });

      var doc = editor.getDoc();

      // Insert variables into editor.
      $('.snippet-variable').click(function () {
        doc.replaceSelection('{{ ' + $(this).text() + ' }}', doc.getCursor());
        return false;
      });

      // Toolbar.
      if (settings.snippetManager.codeMirror.toolbar) {
        createToolbar();
      }

    }
  };

}(jQuery, Drupal));
