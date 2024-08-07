{{ define "funkycore.notes.header" }}
This geeky helm chart proudly brought to you by..

  FUNKY PENGUIN'S
       GEEK COOKBOOK

           \|~|_
           o-o
           /V\
          // \\
         /(   )\
          ^-~-^

> http://geek-cookbook.funkypenguin.co.nz <
{{ end }}

{{ define "funkycore.notes.footer" }}
Got questions? Ideas? Hop into our Discord server at
http://chat.funkypenguin.co.nz - hot, sweaty geeks are waiting to help you out!
{{ end }}

{{ define "funkycore.notes.chartSuggestion"}}
{{ $suggestion := index .Values.funkycore.notes.otherCharts ( mod (randNumeric 4) ( len .Values.funkycore.notes.otherCharts ) ) }}
You could try installing some of our other charts, why not {{ $suggestion.name }}?

Check it out at {{ $suggestion.url }}
{{ end }}