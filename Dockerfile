ARG IMAGE=intersystemsdc/iris-community

FROM $IMAGE
USER root

RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} .

USER irisowner
COPY Installer.cls ./
COPY src src

RUN \
  iris start iris && \
  /bin/echo -e ""    \
    " zn \"%SYS\"" \
    " do ##class(%SYSTEM.Process).CurrentDirectory(\"$PWD\")" \
    " do ##class(%SYSTEM.OBJ).Load(\"Installer.cls\", \"ck\")" \
    " set sc = ##class(App.Installer).setup()"  \
    " zw sc" \
    " if '\$Get(sc) { do ##class(%SYSTEM.Process).Terminate(, 1) }" \
    " halt"   \
  | iris session iris -U %SYS && \
  iris stop iris quietly 
