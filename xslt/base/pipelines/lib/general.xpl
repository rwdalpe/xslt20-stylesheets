<?xml version="1.0" encoding="utf-8"?>
<p:library version="1.0" xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:dbp="http://docbook.github.com/ns/pipeline" xmlns:pxp="http://exproc.org/proposed/steps"
  exclude-inline-prefixes="dbp pxp">
  <!-- Ideally, this pipeline wouldn't rely on an XML Calabash extensions, but it's
    a lot more convenient this way. See generic.xpl for a version with no processor-specific
    extensions. -->
  <p:declare-step type="pxp:set-base-uri">
    <p:input port="source" />
    <p:output port="result" />
    <p:option name="uri" required="true" />
  </p:declare-step>

  <p:declare-step type="cx:message" xmlns:cx="http://xmlcalabash.com/ns/extensions">
    <p:input port="source" sequence="true" />
    <p:output port="result" sequence="true" />
    <p:option name="message" required="true" />
  </p:declare-step>
</p:library>