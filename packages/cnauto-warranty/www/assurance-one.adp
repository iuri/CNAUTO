<master>

<property name="title">@page_title;noquote@</property>
<property name="context">{@page_title;noquote@}</property>

@workflow_html;noquote@

<formtemplate id="assurance"></formtemplate>

<!--
<input type="button" value="Edit" onclick="javascript:parent.location='@assurance_ae_url@'" />
<input type="button" value="Cancel" onclick="javascript:parent.location='@return_url@'" />
</p>
-->
<br />

<if files.rowcount gt 0>
<table>
  <tr>
    <td><h1>cnauto-assurance.Attached_files</h1></td> 
  </tr>
  <tr>
    <multiple name="files">
      <td width="10%">
        <a href="@files.view_image_url@"><img src="/resources/file-storage/file.gif"> &nbsp; @files.description;noquote@</a></td>
    </multiple>
  </tr>
</table>
</if>

<br />
<listtemplate name="parts"></listtemplate>

