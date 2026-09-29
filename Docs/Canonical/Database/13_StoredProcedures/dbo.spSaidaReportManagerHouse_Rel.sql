SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE Procedure [dbo].[spSaidaReportManagerHouse_Rel] ---[dbo].[spSaidaReportManagerHouse_Rel] 'EAWIN201301001BR'
	@Num_Proc	Varchar(16)
as

select 
	Distinct  
	HOU.num_proc_hia,Null Consignee, POrigem.Nome_Pais Pais_Origem, PDestino.Nome_Pais Pais_Destino,
	dst.Nome_Local Destino,HOU.hawb_hia House,HOU.mawb_hia Master,org.Nome_Local Origem,
	Null Shipper,Voo_Hia Vessel,convert(Datetime,dt_emis_hia,105) Dt_Registro,
	Null Cidade_Consignee,
	NULL cd_pes_grupo,
	--PPL.cd_pes_grupo,
	NULL Container,
	Null Incoterm, 
	NULL Carrier,
	--Nome_Cia_Aer Carrier,
	Null CNPJ, 
	Null Terminal,
	null NetWeight,
	--Peso_Real_Hia NetWeight,
	null Viagem,
	NULL Consol,
	--NUM_PROC_MIA Consol, 
	NULL QtyContainer,
	--0 QtyContainer,
	Admin LLP_Unit,
	NULL MOEDA_FRETE,
	--HOU.CD_TP_MOEDA MOEDA_FRETE,
	NULL Vlr_Frete_BL,
	--vlr_frete_efet_hia Vlr_Frete_BL, 
	FF.Apelido FForwarder,
	NULL Nome_CSR,
	--CSR.Nome_Usuario Nome_CSR,
	NULL Agente,
	--AGT.Apelido Agente, 
	NULL Dispacth,
	--'Air' Dispacth,
	NULL R_Origem,
	NULL R_Destino,
	--RORG.nome_regiao R_Origem,
	--RDST.nome_regiao R_Destino,
	0 TEUS,null DeadLine,null bookingnumber,PGRP.Apelido Grupo_Name,
	NULL Notes,
	--Obs_Hia Notes,
	V.nome_usuario Vendedor,PDestino.Form_A, 
	NULL Embalagem,
	--TE.nome_tp_embal Embalagem, 
	NULL Moeda,
	--TM.nome_tp_moeda Moeda,
	Null Endereco , Null Tipo_Container, 
	NULL Peso_Bruto,
	--Peso_Bruto_HIA Peso_Bruto, 
	NULL Peso_Cubado
	--convert(float,LLP.Peso_Cubado_LIA) Peso_Cubado
from 
	house_imp_aer HOU With(nolock)
	--left Join Pessoa PP on PP.cd_pes=cd_consig_hia
	--left Join Endereco ED on ED.cd_pes=cd_consig_hia
	left Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=cd_consig_hia
	left Join Localidade Org with(nolock) on Org.cd_local=cd_org_hia
	left Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais
	left Join Localidade Dst with(nolock) on DST.cd_local=cd_dst_hia
	left Join Pais PDestino with(nolock) on PDestino.cd_pais=DST.cd_pais
--	left Join Pessoa SH on SH.cd_pes=cd_export_hia
	Join Job_imp_Aer Job with(nolock) on job.num_proc_hia=hou.num_proc_hia
	Left Join Cia_Aerea CIA with(nolock) on CIA.cd_cia_Aer=job.cd_cia_aer
	Join LLP_Imp_Aer LLP with(nolock) on LLP.num_proc_lia=hou.num_proc_hia
--	left Join terminal TERM with(nolock) on llp.cd_terminal = TERM.cd_terminal

	Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo
	Left Join Pessoa FF with(nolock) on cd_agente=FF.cd_pes
	--Left Join Usuario CSR with(nolock) on job.cd_usuario=csr.cd_usuario
	--Left Join Pessoa AGT with(nolock) on AGT.cd_pes=cd_agente
	--Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
	--Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
	Left Join Pessoa PGRP with(nolock) on PGRP.cd_pes=GRP.cd_pes_grupo
	Left Join Usuario V with(nolock) on Cd_Vendedor=V.Cd_Usuario
	--left join Volume_Imp_Aer EMB with(nolock) on EMB.Num_Proc_HIA = HOU.Num_Proc_HIA
	--left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal
	--left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
where
	HOU.num_proc_hia=@Num_Proc

UNION ALL

select	
	Distinct hou.num_proc_him,Null Consignee, POrigem.Nome_Pais, PDestino.Nome_Pais,
	dst.Nome_Local Destino,hawb_him House,hou.mawb_him Master,org.Nome_Local Origem,
	Null Shipper,nAVIO_hIM Vessel,convert(Datetime,dt_emis_him,105) Dt_Registro,
	Null Cidade_Consignee,
	NULL cd_pes_grupo,
	--PPL.cd_pes_grupo,
	NULL Container,
	--dbo.[fBusca_Containers_IM](hou.NUM_PROC_HIM) Container,
	Null Incoterm, 
	NULL Carrier,
	--Nome_Armador Carrier, 
	Null CNPJ,
	Null,
	null NetWeight,
	--Peso_Liquido_him,
	null Viagem,
	--Viagem_him,
	NULL Consol,
	--NUM_PROC_MIM CONSOL, 
	NULL QtyContainer,
	--[dbo].[Qty_Container](num_proc_lim) QtyContainer,
	Admin, 
	NULL MOEDA_FRETE,
	--HOU.CD_TP_MOEDA MOEDA_FRETE,
	NULL Vlr_Frete_BL,
	--vlr_frete_efet_him Vlr_Frete_BL, 
	FF.Apelido FForwarder,
	NULL Nome_CSR,
	--CSR.Nome_Usuario Nome_CSR,
	NULL Agente,
	--AGT.Apelido Agente,
	NULL Dispacth,
	--Nome_Tp_Carga Dispatch,
	NULL R_Origem,
	NULL R_Destino,
	--RORG.nome_regiao R_Origem,
	--RDST.nome_regiao R_Destino,
	dbo.fBusca_TEUS(num_proC_lim) TEUS, null DeadLine,
	replace(replace(left(NR_Reserva,40),'=',''),'/','') bookingnumber,
	PGRP.Apelido Grupo_Name, 
	NULL Notes,
	--obs_him Notes,
	V.Nome_usuario Vendedor,PDestino.Form_A, 
	NULL Embalagem,
	--TE.nome_tp_embal Embalagem, 
	NULL Moeda,
	--TM.nome_tp_moeda Moeda,
	Null Endereco , 
	NULL Tipo_Container,
	--[dbo].[fBusca_Containers_TP](@Num_Proc) Tipo_Container, 
	NULL Peso_Bruto,
	--Peso_Bruto_HIM Peso_Bruto, 
	null Peso_Cubado
from 
	house_imp_mar HOU with(nolock)
--	Join Pessoa PP on PP.cd_pes=cd_consig_him
--	left Join Endereco ED on ED.cd_pes=cd_consig_him
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=cd_consig_him
	Join Localidade Org with(nolock) on Org.cd_local=cd_org_him
	Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais
	Join Localidade Dst with(nolock) on DST.cd_local=cd_dst_him
	Join Pais PDestino with(nolock) on PDestino.cd_pais=DST.cd_pais
--	Join Pessoa SH on SH.cd_pes=cd_export_him
	Join Job_imp_Mar Job with(nolock) on job.num_proc_him=hou.num_proc_him
	Join Armador CIA with(nolock) on CIA.cd_armador=job.cd_armador
	Join LLP_Imp_Mar LLP with(nolock) on LLP.num_proc_lim=hou.num_proc_him
--	LEft Join TErminal tERM with(nolock) on TERM.cd_terminal=llp.cd_terminal
	Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo		
	Left Join Pessoa  FF with(nolock) on llp.cd_forwarder=FF.cd_pes
	--Left Join Usuario CSR with(nolock) on job.cd_usuario=csr.cd_usuario
	--Left Join Pessoa AGT with(nolock) on AGT.cd_pes=cd_agente
	--Left Join Tipo_Carga  TC with(nolock) on LLP.cd_tp_carga=TC.cd_tp_carga
	--Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
	--Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
	Left Join Pessoa PGRP with(nolock) on PGRP.cd_pes=GRP.cd_pes_grupo
	Left Join Usuario V with(nolock) on Cd_Vendedor=V.Cd_Usuario
	--left join Volume_Imp_Mar EMB with(nolock) on EMB.Num_Proc_HIM = HOU.Num_Proc_HIM
	--left join tipo_embalagem TE with(nolock)  on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal
	--left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
where
	hou.num_proc_him=@num_proc

UNION ALL

select Distinct HOU.num_proc_hio,Null Consignee, POrigem.Nome_Pais, PDestino.Nome_Pais,
	dst.Nome_Local Destino,hawb_hio House,mawb_hio Master,org.Nome_Local Origem,
	Null Shipper,NULL Vessel,convert(Datetime,dt_emis_hio,105) Dt_Registro,
	Null Cidade_Consignee	,
	NULL cd_pes_grupo,
	--PPL.cd_pes_grupo,
	NULL CONTAINER, 
	Null Incoterm, 
	NULL Carrier,
	--CIA.apelido, 
	Null CNPJ, 
	Null Terminal,
	null NetWeight,
	--Peso_Real_Hio,
	null,
	NULL,
	NULL QtyContainer,
	--0 QtyContainer,
	admin, 
	NULL MOEDA_FRETE,
	--HOU.CD_TP_MOEDA MOEDA_FRETE,
	NULL Vlr_Frete_BL,
	--vlr_frete_efet_hio Vlr_Frete_BL,
	FF.Apelido FForwarder,
	NULL Nome_CSR,
	--CSR.Nome_Usuario Nome_CSR,
	NULL Agente,
	--AGT.apelido Agente,
	NULL Dispacth,
	--Tipo_Lio,
	NULL R_Origem,
	NULL R_Destino,
	--RORG.nome_regiao R_Origem,
	--RDST.nome_regiao R_Destino,
	 0 TEUS, null DeadLine, null BookingNumber,
	PGRP.Apelido Grupo_Name, 
	NULL Notes,
	--Obs_Hio Notes, 
	V.Nome_Usuario Vendedor,PDestino.Form_A, 
	NULL Embalagem,
	--TE.nome_tp_embal Embalagem, 
	NULL Moeda,
	--TM.nome_tp_moeda Moeda,
	Null Endereco,
	Null Tipo_Container, 
	NULL Peso_Bruto,
	--Peso_Bruto_HIO Peso_Bruto, 
	NULL Peso_Cubado
	--convert(float,LLP.Peso_Cubado_LIO) Peso_Cubado
from 
	house_imp_out HOU with(nolock)
--	Join Pessoa PP on PP.cd_pes=cd_consig_hio
--	left Join Endereco ED on ED.cd_pes=cd_consig_hio
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=cd_consig_hio
	Join Localidade Org with(nolock) on Org.cd_local=cd_org_hio
	Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais
	Join Localidade Dst with(nolock) on DST.cd_local=cd_dst_hio
	Join Pais PDestino with(nolock) on PDestino.cd_pais=DST.cd_pais
--	Join Pessoa SH on SH.cd_pes=cd_export_hio
	Join LLP_Imp_out LLP with(nolock) on LLP.num_proc_lio=hou.num_proc_hio
	LEft Join Pessoa CIA with(nolock)  on CIA.cd_pes=LLP.cd_carrier
	Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo
	Left Join Pessoa FF with(nolock) on llp.cd_forwarder=FF.cd_pes
	--Left Join Usuario CSR with(nolock) on llp.cd_usuario=csr.cd_usuario
	--Left Join Pessoa AGT with(nolock) on AGT.cd_pes=cd_agente
	--Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
	--Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
	Left Join Pessoa PGRP with(nolock) on PGRP.cd_pes=GRP.cd_pes_grupo
	Left Join Usuario V with(nolock) on Cd_Vendedor=V.Cd_Usuario
	--left join Volume_Imp_OUT EMB with(nolock) on EMB.Num_Proc_HIO = HOU.Num_Proc_HIO
	--left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal
	--left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
--	LEft Join TErminal tERM with(nolock) on TERM.cd_terminal=llp.cd_terminal
where
	HOU.num_proc_hio=@Num_proc

union ALL

select Distinct hou.num_proc_HEA,Null Consignee, POrigem.Nome_Pais, PDestino.Nome_Pais,
	dst.Nome_Local Destino,hawb_HEA House,hou.mawb_HEA Master,org.Nome_Local Origem,
	Null Shipper,Voo_HEA Vessel,convert(Datetime,dt_emis_HEA,105) Dt_Registro,
	DST.Cidade_Local Cidade_Consignee	,
	NULL cd_pes_grupo,
	--PPL.cd_pes_grupo,
	NULL CONTAINER,
	Null Incoterm, 
	NULL Carrier,
	--Nome_CIa_Aer, 
	Null CNPJ, 
	Null Terminal, 
	null NetWeight,
	--peso_real_hea,
	null,
	NUM_PROC_MEA,
	NULL QtyContainer,
	--0 QtyContainer ,
	admin,
	NULL MOEDA_FRETE,
	-- HOU.CD_TP_MOEDA MOEDA_FRETE,
	NULL Vlr_Frete_BL,
	--vlr_frete_tot_hea Vlr_Frete_BL,
	FF.Apelido FForwarder,
	NULL Nome_CSR,
	--CSR.Nome_Usuario Nome_CSR,
	null,
	NULL Dispacth,
	--'Air',
	NULL R_Origem,
	NULL R_Destino,
	--RORG.nome_regiao R_Origem,
	--RDST.nome_regiao R_Destino,
	 0 TEUS,null DeadLine, null BookingNumber,
	PGRP.Apelido Grupo_Name,
	NULL Notes,
	--Obs_HEA Notes,
	V.Nome_USuario Vendedor,PDestino.Form_A, 
	NULL Embalagem,
	--TE.nome_tp_embal Embalagem, 
	NULL Moeda,
	--TM.nome_tp_moeda Moeda,
	Null Endereco,
	Null  Tipo_Container, 
	NULL Peso_Bruto,
	--Peso_Bruto_HEA Peso_Bruto, 
	NULL Peso_Cubado
	--convert(float,LLP.Peso_Cubado_LEA) Peso_Cubado
from 
	house_EXP_aer hou with(nolock)
	join llp_exp_aer LLP with(nolock) on LLP.num_proc_lea = HOU.num_proc_hea
--	Left Join Pessoa PP on PP.cd_pes=cd_consig_HEA
--	left Join Endereco ED on ED.cd_pes=cd_consig_hea
	Left Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=cd_export_hea
	Left Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEA
	Left Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais
	Left Join Localidade Dst with(nolock) on DST.cd_local=cd_dst_HEA
	Left Join Pais PDestino with(nolock) on PDestino.cd_pais=DST.cd_pais
--	Left Join Pessoa SH on SH.cd_pes=cd_export_HEA
	Left Join Cia_Aerea CIA with(nolock) on CIa.cd_cia_aer=llp.Cd_CiaAerea_Lea
	Left Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo
	Left Join Job_exp_Aer Job with(nolock) on job.num_proc_hea=hou.num_proc_hea
	Left Join Pessoa FF with(nolock) on Cd_Agente=FF.cd_pes
	--Left Join Usuario CSR with(nolock) on job.cd_usuario=csr.cd_usuario
	--Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
	--Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
	Left Join Pessoa PGRP with(nolock) on PGRP.cd_pes=GRP.cd_pes_grupo
	Left Join Usuario V with(nolock) on Cd_Vendedor=V.Cd_Usuario
	--left join Volume_Exp_AER EMB with(nolock) on EMB.Num_Proc_HEA = HOU.Num_Proc_HEA
	--left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal
	left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
where
	hou.num_proc_hea=@num_proc

UNION

select Distinct hou.num_proc_HEM,Null Consignee, POrigem.Nome_Pais, PDestino.Nome_Pais,
	dst.Nome_Local Destino,hawb_HEM House,HOU.mawb_HEM Master,org.Nome_Local Origem,
	Null Shipper,nAVIO_HEM Vessel,convert(Datetime,dt_emis_HEM,105) Dt_Registro,
	Null Cidade_Consignee	,
	NULL cd_pes_grupo,
	--PPL.cd_pes_grupo, 
	NULL Container,
	--DBO.fBusca_Containers(HOU.NUM_PROC_HEM) Containers,
	Null Incoterm, 
	NULL Carrier,
	--Nome_armador, 
	Null CNPJ,
	Null Terminal,
	null NetWeight,
	--peso_liquido_hem,
	null Viagem,
	--viagem_hem,
	NULL Consol,
	--HOU.NUM_PROC_MEM,  
	NULL QtyContainer,
	--[dbo].[Qty_Container](num_proc_lem) QtyContainer,
	Admin,
	NULL MOEDA_FRETE,
	--HOU.CD_TP_MOEDA MOEDA_FRETE,
	NULL Vlr_Frete_BL,
	--vlr_frete_tot_hem Vlr_Frete_BL, 
	FF.Apelido,
	NULL Nome_CSR,
	--CSR.Nome_Usuario Nome_CSR,
	NULL Agente,
	--AGT.Nome_Raz_Soc,
	NULL Dispacth,
	--Nome_tp_carga,
	NULL R_Origem,
	NULL R_Destino,
	--RORG.nome_regiao R_Origem,
	--RDST.nome_regiao R_Destino,
	 dbo.fBusca_TEUS(num_proC_lem) TEUS,
	job.Dead_Line, Nr_Reserva, PGRP.apelido Grupo_Name, 
	NULL Notes,
	--Obs_Hem Notes,
	V.Nome_Usuario Vendedor,PDestino.Form_A, 
	NULL Embalagem,
	--TE.nome_tp_embal Embalagem, 
	NULL Moeda,
	--TM.nome_tp_moeda Moeda,
	Null Endereco, 
	NULL Tipo_Container,
	--[dbo].[fBusca_Containers_TP](@Num_Proc) Tipo_Container, 
	NULL Peso_Bruto,
	--Peso_Bruto_HEM Peso_Bruto, 
	null Peso_Cubado
from 
	house_EXP_mar hou with(nolock)
--	Join Pessoa PP on PP.cd_pes=cd_consig_HEM
---	left Join Endereco ED on ED.cd_pes=cd_consig_hEm
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=cd_export_hem
	Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEM
	Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais
	Join Localidade Dst with(nolock) on DST.cd_local=cd_dst_HEM
	Join Pais PDestino with(nolock) on PDestino.cd_pais=DST.cd_pais
--	Join Pessoa SH on SH.cd_pes=cd_export_HEM
	Join LLP_Exp_MAr LLP with(nolock) on LLP.num_proc_lem=hou.num_proc_hem		
	LEFT Join Armador CIA with(nolock) on CIA.cd_armador=cd_armador_lem
--	left Join Terminal TERM with(nolock) on TERM.cd_terminal=llp.cd_terminal
	Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo
	Join Job_Exp_Mar Job with(nolock) on Job.num_proc_hem=hou.num_proc_hem
	Left Join Pessoa FF with(nolock) on cd_agente=FF.cd_pes
	--Left Join Usuario CSR with(nolock) on job.cd_usuario=csr.cd_usuario
	--Left Join Tipo_carga TC with(nolock) on TC.cd_tp_carga=LLP.cd_tp_carga
	--Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
	--Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
	--lEFT jOIN Pessoa AGT with(nolock) on Job.cd_agente=AGT.cd_pes
	Left Join Pessoa PGRP with(nolock) on PGRP.cd_pes=GRP.cd_pes_grupo
	Left Join Usuario V with(nolock) on Cd_Vendedor=V.Cd_Usuario
	--left join Volume_Exp_MAR EMB with(nolock) on EMB.Num_Proc_HEM = HOU.Num_Proc_HEM
	--left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal
	--left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
where
	hou.num_proc_HEM=@num_proc

UNION

select Distinct HOU.num_proc_HEO,Null Consignee, POrigem.Nome_Pais, PDestino.Nome_Pais,
	dst.Nome_Local Destino,hawb_HEO House,mawb_HEO Master,org.Nome_Local Origem,
	Null Shipper,NULL Vessel,convert(Datetime,dt_emis_HEO,105) Dt_Registro,
	Null Cidade_Consignee	,
	NULL cd_pes_grupo,
	--PPL.cd_pes_grupo,
	null container,
	Null Incoterm, 
	NULL Carrier,
	--CIA.APELIDO,
	Null CNPJ, 
	null,
	null NetWeight,
	--peso_real_heo,
	null,
	NULL,
	NULL QtyContainer,
	--0 QtyContainer,
	admin,
	NULL MOEDA_FRETE,
	--HOU.CD_TP_MOEDA MOEDA_FRETE,
	NULL Vlr_Frete_BL,
	--vlr_frete_efet_heo Vlr_Frete_BL,
	ff.APELIDO,
	NULL Nome_CSR,
	--CSR.Nome_Usuario Nome_CSR,
	null,
	NULL Dispacth,
	--Tipo_leo,
	NULL R_Origem,
	NULL R_Destino,
	--RORG.nome_regiao R_Origem,
	--RDST.nome_regiao R_Destino,
	0 TEUS, null,null, PGRP.Apelido Grupo_Name,
	NULL Notes,
	--Obs_HEO Notes, 
	V.Nome_Usuario Vendedor,PDestino.Form_A, 
	NULL Embalagem,
	--TE.nome_tp_embal Embalagem, 
	NULL Moeda,
	--TM.nome_tp_moeda Moeda,
	Null Endereco, Null, 
	NULL Peso_Bruto,
	--Peso_Bruto_HEO Peso_Bruto, 
	NULL Peso_Cubado_LEO
	--convert(float,LLP.Peso_Cubado_LEO) Peso_Cubado
from 
	house_EXP_out hou with(nolock)
--	Join Pessoa PP on PP.cd_pes=cd_consig_HEO
--	left Join Endereco ED on ED.cd_pes=cd_consig_heo
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=cd_export_heo
	Join Localidade Org with(nolock) on Org.cd_local=cd_org_HEO
	Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais
	Join Localidade Dst with(nolock) on DST.cd_local=cd_dst_HEO
	Join Pais PDestino with(nolock) on PDestino.cd_pais=DST.cd_pais
--	Join Pessoa SH on SH.cd_pes=cd_export_HEO
	jOIN llp_EXP_OUT llp with(nolock) on llp.num_proc_leo=hou.num_proc_heo
	Left Join Pessoa CIA with(nolock) on CIA.cd_pes=cd_carrier
	Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=PPL.cd_pes_grupo
	Left Join Pessoa  FF with(nolock) on llp.cd_forwarder=FF.cd_pes
	--Left Join Usuario CSR with(nolock) on llp.cd_usuario=csr.cd_usuario
	--Left Join Regiao RORG with(nolock) on org.cd_regiao=RORG.cd_regiao
	--Left Join Regiao RDST with(nolock) on DST.cd_regiao=RDST.cd_regiao
	Left Join Pessoa PGRP with(nolock) on PGRP.cd_pes=GRP.cd_pes_grupo
	Left Join Usuario V with(nolock) on Cd_Vendedor=V.Cd_Usuario
	--left join Volume_Exp_OUT EMB with(nolock) on EMB.Num_Proc_HEO = HOU.Num_Proc_HEO
	--left join tipo_embalagem TE with(nolock) on TE.Cd_tp_Embal = EMB.Cd_Tp_Embal
	--left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Cd_Tp_Moeda
where
	HOU.num_proc_HEO=@num_proc











GO
