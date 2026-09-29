SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Alerta_Ocorrencia where cd_tp_ocor = '108'  
--select * from Hist_Geral where hsgprocesso  
--select * from grupo where cd_pes_grupo = '10'  
--incluido dbo.fBusca_TipoDocCliente('N',Num_Proc_lim,9) Customer_PO - cadu 20-9-12  
--alterado pra pegar de 30 e 30 minutos - getdate() -  0.020833  
--3-05-2018 - ncluido o tipo 110   
CREATE procedure [dbo].[spATL_AlertaTipoOcorrenciaV2_Rel]  
  
AS  
  
--criado para enviar apenas o tipo ocorrencia 108, q nao esta disponivel ao cliente  
 --108 Alteração de Documentos  
 --111 LI Reg. Especial  
 --112 Necessita Drawback   
 --110 Exclusão da Nota Fiscal  
  
Select  Distinct   
 LLP.num_proc Job,  
 (case when US.Email = '' OR US.Email is null then  
  AO.ResponderPara  
  else US.Email end) ResponderPara,  
 Assunto,  
 HG.cd_tp_ocor,  
 (convert(varchar(10),hsgdata,103) + ':' + hsddescricao) Mensagem,  
 Nome_Tp_Ocor Ocorrencia,  
 dbo.fBusca_TipoDocCliente('N',LLP.num_proc,1) PO,  
 dbo.fBusca_TipoDocCliente('N',LLP.num_proc,9) Customer_PO,  
 dbo.fBusca_TipoDocCliente('N',LLP.num_proc,3) SalesOrder,  
 Org.Nome_Local Origem,   
 DST.Nome_Local Destino,  
 convert(char(20),LLP.ATD,107) ATD,   
 convert(char(20),LLP.ATA,107) ATA,  
 Nome_Usuario CSR_Responsible,   
 AO.Emails  
from vwCliente_Alerta LLP with(nolock)   
 Join Pessoa_LLP PLLP with (nolock) on PLLP.cd_pes=LLP.cd_cliente  
 Join Alerta_Ocorrencia AO with (nolock) on (AO.cd_pes_grupo=PLLP.cd_pes_GRUPO or AO.Cd_Pes_Grupo = '10017') and AO.Modal =LEFT(LLP.num_proc,2)  
 Join Hist_Geral HG with (nolock) on HG.hsgprocesso=LLP.num_proc and disp_cliente='N' and HSGDataConf is null AND HG.CD_tP_OCOR=AO.CD_TP_OCOR   
 Join Usuario US with (nolock) on US.cd_usuario=LLP.cd_usuario  
 Join Tipo_Ocorrencia TP with (nolock) on TP.cd_tp_ocor=AO.cd_tp_ocor  
 Join Localidade Org with (nolock) on Org.cd_local=llp.cd_org  
 Join Localidade Dst with (nolock) on DST.cd_local=llp.cd_dst  
Where  
 --HSGdata >=getdate()-0.041666667  
 HSGdata >=getdate()-0.020833  
 and AO.cd_tp_ocor in ('108','110','111','112','118')  
   
union all  
  
Select   
 Distinct num_proc Job,  
 (case when US.Email = '' OR US.Email is null then  
  AO.ResponderPara  
  else US.Email end) ResponderPara,  
 Assunto,HG.cd_tp_ocor,(convert(varchar(10),hsgdata,103) + ':' + hsddescricao) Mensagem,Nome_Tp_Ocor Ocorrencia,  
 dbo.fBusca_TipoDocCliente('N',LLP.num_proc,1) PO,  
 dbo.fBusca_TipoDocCliente('N',LLP.num_proc,9) Customer_PO,  
 dbo.fBusca_TipoDocCliente('N',LLP.num_proc,3) SalesOrder,  
 Org.Nome_Local Origem, DST.Nome_Local Destino,  
 convert(char(20),LLP.ATD,107) ATD,   
 convert(char(20),LLP.ATA,107) ATA,   
 Nome_Usuario CSR_Responsible, AO.Emails  
from vwCliente_Alerta LLP with(nolock)   
 Join Pessoa_LLP PLLP with (nolock) on PLLP.cd_pes=LLP.cd_cliente  
 Join Alerta_Ocorrencia AO with (nolock) on (AO.cd_pes_grupo=PLLP.cd_pes_GRUPO or AO.Cd_Pes_Grupo = '10017') and AO.Modal =LEFT(LLP.num_proc,2)  
 Join Hist_Geral HG with (nolock) on HG.hsgprocesso=LLP.num_proc and disp_cliente='S' and HSGDataConf is null AND HG.CD_tP_OCOR=AO.CD_TP_OCOR    
 Join Usuario US with (nolock) on US.cd_usuario=LLP.cd_usuario  
 Join Tipo_Ocorrencia TP with (nolock) on TP.cd_tp_ocor=AO.cd_tp_ocor  
 Join Localidade Org with (nolock) on Org.cd_local=llp.cd_org  
 Join Localidade Dst with (nolock) on DST.cd_local=llp.cd_dst  
Where  
 --HSGdata >=getdate()-0.041666667  
 HSGdata >=getdate()-0.020833  
  
--Select  Distinct   
-- LLP.num_proc Job,  
-- (case when US.Email = '' OR US.Email is null then  
--  AO.ResponderPara  
--  else US.Email end) ResponderPara,  
-- Assunto,  
-- HG.cd_tp_ocor,  
-- (convert(varchar(10),hsgdata,103) + ':' + hsddescricao) Mensagem,  
-- Nome_Tp_Ocor Ocorrencia,  
-- dbo.fBusca_TipoDocCliente('N',LLP.num_proc,1) PO,  
-- dbo.fBusca_TipoDocCliente('N',LLP.num_proc,9) Customer_PO,  
-- dbo.fBusca_TipoDocCliente('N',LLP.num_proc,3) SalesOrder,  
-- Org.Nome_Local Origem,   
-- DST.Nome_Local Destino,  
-- convert(char(20),LLP.ATD,107) ATD,   
-- convert(char(20),LLP.ATA,107) ATA,  
-- Nome_Usuario CSR_Responsible,   
-- AO.Emails  
--from vwCliente_Alerta LLP with(nolock)   
-- Join Pessoa_LLP PLLP with (nolock) on PLLP.cd_pes=LLP.cd_cliente  
-- Join Alerta_Ocorrencia AO with (nolock) on (AO.cd_pes_grupo=PLLP.cd_pes_GRUPO or AO.Cd_Pes_Grupo = '10017') and AO.Modal =LEFT(LLP.num_proc,2)  
-- Join Hist_Geral HG with (nolock) on HG.hsgprocesso=LLP.num_proc and disp_cliente='N' and HSGDataConf is null AND HG.CD_tP_OCOR=AO.CD_TP_OCOR   
-- Join Usuario US with (nolock) on US.cd_usuario=LLP.cd_usuario  
-- Join Tipo_Ocorrencia TP with (nolock) on TP.cd_tp_ocor=AO.cd_tp_ocor  
-- Join Localidade Org with (nolock) on Org.cd_local=llp.cd_org  
-- Join Localidade Dst with (nolock) on DST.cd_local=llp.cd_dst  
--Where  
-- --HSGdata >=getdate()-0.041666667  
-- HSGdata >=getdate()-0.020833  
-- and AO.cd_tp_ocor in ('108','110')  
   
--union all  
  
--Select   
-- Distinct Num_Proc_Lem Job,  
-- (case when US.Email = '' OR US.Email is null then  
--  AO.ResponderPara  
--  else US.Email end) ResponderPara,  
-- Assunto,HG.cd_tp_ocor,(convert(varchar(10),hsgdata,103) + ':' + hsddescricao) Mensagem,Nome_Tp_Ocor Ocorrencia,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_Lem,1) PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lem,9) Customer_PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_Lem,3) SalesOrder,Org.Nome_Local Origem, DST.Nome_Local Destino,  
-- convert(char(20),ATD_LEM,107) ATD, convert(char(20),ATA_LEM,107) ATA,Nome_Usuario CSR_Responsible, AO.Emails  
--From   
-- LLP_Exp_Mar LLP with(nolock)  
-- Join House_Exp_Mar Hou with(nolock) on hou.num_proc_hem=Num_Proc_Lem  
-- Join Pessoa_LLP PLLP with (nolock) on PLLP.cd_pes=cd_export_hem  
-- Join Alerta_Ocorrencia AO with (nolock) on (AO.cd_pes_grupo=PLLP.cd_pes_GRUPO or AO.Cd_Pes_Grupo = '10017') and AO.Modal='EM'  
-- Join Hist_Geral HG with (nolock) on HG.hsgprocesso=num_proc_lem and disp_cliente='S' and HSGDataConf is null AND hg.CD_tP_OCOR=AO.CD_TP_OCOR  
-- Join Job_Exp_Mar JOb with (nolock) on job.num_proc_hem=num_proc_lem  
-- Join Usuario US with (nolock) on US.cd_usuario=Job.cd_usuario  
-- Join Tipo_Ocorrencia TP with (nolock) on TP.cd_tp_ocor=AO.cd_tp_ocor  
-- Join Localidade Org with (nolock) on Org.cd_local=cd_org_hem  
-- Join Localidade Dst with (nolock) on DST.cd_local=cd_dst_hem  
--Where  
-- --HSGdata >=getdate()-0.041666667  
-- HSGdata >=getdate()-0.020833  
   
  
  
--Union all  
  
--Select   
-- Distinct Num_Proc_lim Job,  
-- --US.Email ResponderPara,  
-- (case when US.Email = '' OR US.Email is null then  
--  AO.ResponderPara  
--  else US.Email end) ResponderPara,  
-- Assunto,HG.cd_tp_ocor,(convert(varchar(10),hsgdata,103) + ':' + hsddescricao) Mensagem,Nome_Tp_Ocor Ocorrencia,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lim,1) PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lim,9) Customer_PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lim,3) SalesOrder,Org.Nome_Local Origem, DST.Nome_Local Destino,  
-- convert(char(20),ATD_LIM,107) ATD, convert(char(20),ATA_LIM,107) ATA,Nome_Usuario CSR_Responsible, AO.Emails  
--From   
-- LLP_imp_Mar LLP with(nolock)  
-- Join House_imp_Mar Hou with(nolock) on hou.num_proc_him=Num_Proc_lim  
-- Join Pessoa_LLP PLLP with (nolock) on PLLP.cd_pes=cd_consig_him  
-- Join Alerta_Ocorrencia AO with (nolock) on (AO.cd_pes_grupo=PLLP.cd_pes_GRUPO or AO.Cd_Pes_Grupo = '10017')and AO.Modal='IM'  
-- Join Hist_Geral HG with (nolock) on HG.hsgprocesso=num_proc_lim and disp_cliente='S' and HSGDataConf is null AND hg.CD_tP_OCOR=AO.CD_TP_OCOR  
-- Join Job_imp_Mar JOb with (nolock) on job.num_proc_him=num_proc_lim  
-- Join Usuario US with (nolock) on US.cd_usuario=Job.cd_usuario  
-- Join Tipo_Ocorrencia TP with (nolock) on TP.cd_tp_ocor=AO.cd_tp_ocor  
-- Join Localidade Org with (nolock) on Org.cd_local=cd_org_him  
-- Join Localidade Dst with (nolock) on DST.cd_local=cd_dst_him  
--Where  
-- --HSGdata >=getdate()-0.041666667  
-- HSGdata >=getdate()-0.020833  
  
----Incluido os outros modais dia 26-06-12 - Cadu  
  
--UNION ALL  
  
--Select   
-- Distinct Num_Proc_Lea Job,  
-- --US.Email ResponderPara,  
-- (case when US.Email = '' OR US.Email is null then  
--  AO.ResponderPara  
--  else US.Email end) ResponderPara,  
-- Assunto,HG.cd_tp_ocor,(convert(varchar(10),hsgdata,103) + ':' + hsddescricao) Mensagem,Nome_Tp_Ocor Ocorrencia,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,1) PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lea,9) Customer_PO,   
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,3) SalesOrder,Org.Nome_Local Origem, DST.Nome_Local Destino,  
-- convert(char(20),ATD_LEA,107) ATD, convert(char(20),ATA_LEA,107) ATA,Nome_Usuario CSR_Responsible, AO.Emails  
--From   
-- LLP_Exp_Aer LLP with(nolock)  
-- Join House_Exp_Aer Hou with(nolock) on hou.num_proc_hea=Num_Proc_Lea  
-- Join Pessoa_LLP PLLP with (nolock) on PLLP.cd_pes=cd_export_hea  
-- Join Alerta_Ocorrencia AO with (nolock) on (AO.cd_pes_grupo=PLLP.cd_pes_GRUPO or AO.Cd_Pes_Grupo = '10017') and AO.Modal='EA'  
-- Join Hist_Geral HG with (nolock) on HG.hsgprocesso=num_proc_lea and disp_cliente='S' and HSGDataConf is null AND hg.CD_tP_OCOR=AO.CD_TP_OCOR  
-- Join Job_Exp_Aer JOb with (nolock) on job.num_proc_hea=num_proc_lea  
-- Join Usuario US with (nolock) on US.cd_usuario=Job.cd_usuario  
-- Join Tipo_Ocorrencia TP with (nolock) on TP.cd_tp_ocor=AO.cd_tp_ocor  
-- Join Localidade Org with (nolock) on Org.cd_local=cd_org_hea  
-- Join Localidade Dst with (nolock) on DST.cd_local=cd_dst_hea  
--Where  
-- --HSGdata >=getdate()-0.041666667  
-- HSGdata >=getdate()-0.020833  
  
  
--Union all  
  
--Select   
-- Distinct Num_Proc_lia Job,  
-- --US.Email ResponderPara,  
-- (case when US.Email = '' OR US.Email is null then  
--  AO.ResponderPara  
--  else US.Email end) ResponderPara,  
-- Assunto,HG.cd_tp_ocor,(convert(varchar(10),hsgdata,103) + ':' + hsddescricao) Mensagem,Nome_Tp_Ocor Ocorrencia,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lia,1) PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lia,9) Customer_PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lia,3) SalesOrder,Org.Nome_Local Origem, DST.Nome_Local Destino,  
-- convert(char(20),ATD_LIA,107) ATD, convert(char(20),ATA_LIA,107) ATA,Nome_Usuario CSR_Responsible, AO.Emails  
--From   
-- LLP_imp_Aer LLP with(nolock)  
-- Join House_imp_Aer Hou with(nolock) on hou.num_proc_hia=Num_Proc_lia  
-- Join Pessoa_LLP PLLP with (nolock) on PLLP.cd_pes=cd_consig_hia  
-- Join Alerta_Ocorrencia AO with (nolock) on (AO.cd_pes_grupo=PLLP.cd_pes_GRUPO or AO.Cd_Pes_Grupo = '10017') and AO.Modal='IA'  
-- Join Hist_Geral HG with (nolock) on HG.hsgprocesso=num_proc_lia and disp_cliente='S' and HSGDataConf is null AND hg.CD_tP_OCOR=AO.CD_TP_OCOR  
-- Join Job_imp_Aer JOb with (nolock) on job.num_proc_hia=num_proc_lia  
-- Join Usuario US with (nolock) on US.cd_usuario=Job.cd_usuario  
-- Join Tipo_Ocorrencia TP with (nolock) on TP.cd_tp_ocor=AO.cd_tp_ocor  
-- Join Localidade Org with (nolock) on Org.cd_local=cd_org_hia  
-- Join Localidade Dst with (nolock) on DST.cd_local=cd_dst_hia  
--Where  
-- --HSGdata >=getdate()-0.041666667  
-- HSGdata >=getdate()-0.020833  
  
--UNION ALL  
  
--Select   
-- Distinct Num_Proc_Leo Job,  
-- --US.Email ResponderPara,  
-- (case when US.Email = '' OR US.Email is null then  
--  AO.ResponderPara  
--  else US.Email end) ResponderPara,  
-- Assunto,HG.cd_tp_ocor,(convert(varchar(10),hsgdata,103) + ':' + hsddescricao) Mensagem,Nome_Tp_Ocor Ocorrencia,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,1) PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_leo,9) Customer_PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,3) SalesOrder,Org.Nome_Local Origem, DST.Nome_Local Destino,  
-- convert(char(20),ATD_LEO,107) ATD, convert(char(20),ATA_LEO,107) ATA,Nome_Usuario CSR_Responsible, AO.Emails  
--From   
-- LLP_Exp_Out LLP with(nolock)  
-- Join House_Exp_Out Hou with(nolock) on hou.num_proc_heo=Num_Proc_Leo  
-- Join Pessoa_LLP PLLP with (nolock) on PLLP.cd_pes=cd_export_heo  
-- Join Alerta_Ocorrencia AO with (nolock) on (AO.cd_pes_grupo=PLLP.cd_pes_GRUPO or AO.Cd_Pes_Grupo = '10017') and AO.Modal='EO'  
-- Join Hist_Geral HG with (nolock) on HG.hsgprocesso=num_proc_leo and disp_cliente='S' and HSGDataConf is null AND hg.CD_tP_OCOR=AO.CD_TP_OCOR  
-- --Join Job_Exp_Out JOb with (nolock) on job.num_proc_heo=num_proc_leo  
-- Join Usuario US with (nolock) on US.cd_usuario=LLP.cd_usuario  
-- Join Tipo_Ocorrencia TP with (nolock) on TP.cd_tp_ocor=AO.cd_tp_ocor  
-- Join Localidade Org with (nolock) on Org.cd_local=cd_org_heo  
-- Join Localidade Dst with (nolock) on DST.cd_local=cd_dst_heo  
--Where  
-- --HSGdata >=getdate()-0.041666667  
-- HSGdata >=getdate()-0.020833  
  
  
--Union all  
  
--Select   
-- Distinct Num_Proc_lio Job,  
-- --US.Email ResponderPara,   
-- (case when US.Email = '' OR US.Email is null then  
--  AO.ResponderPara  
--  else US.Email end) ResponderPara,  
-- Assunto,HG.cd_tp_ocor,(convert(varchar(10),hsgdata,103) + ':' + hsddescricao) Mensagem,Nome_Tp_Ocor Ocorrencia,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lio,1) PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lio,9) Customer_PO,  
-- dbo.fBusca_TipoDocCliente('N',Num_Proc_lio,3) SalesOrder,Org.Nome_Local Origem, DST.Nome_Local Destino,  
-- convert(char(20),ATD_LIO,107) ATD, convert(char(20),ATA_LIO,107) ATA,Nome_Usuario CSR_Responsible, AO.Emails  
--From   
-- LLP_imp_Out LLP with(nolock)  
-- Join House_imp_Out Hou with(nolock) on hou.num_proc_hio=Num_Proc_lio  
-- Join Pessoa_LLP PLLP with (nolock) on PLLP.cd_pes=cd_consig_hio  
-- Join Alerta_Ocorrencia AO with (nolock) on (AO.cd_pes_grupo=PLLP.cd_pes_GRUPO or AO.Cd_Pes_Grupo = '10017') and AO.Modal='IO'  
-- Join Hist_Geral HG with (nolock) on HG.hsgprocesso=num_proc_lio and disp_cliente='S' and HSGDataConf is null AND hg.CD_tP_OCOR=AO.CD_TP_OCOR  
-- --Join Job_imp_Out JOb with (nolock) on job.num_proc_hio=num_proc_lio  
-- Join Usuario US with (nolock) on US.cd_usuario=LLP.cd_usuario  
-- Join Tipo_Ocorrencia TP with (nolock) on TP.cd_tp_ocor=AO.cd_tp_ocor  
-- Join Localidade Org with (nolock) on Org.cd_local=cd_org_hio  
-- Join Localidade Dst with (nolock) on DST.cd_local=cd_dst_hio  
--Where  
-- --HSGdata >=getdate()-0.041666667  
-- HSGdata >=getdate()-0.020833
GO
