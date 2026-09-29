SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Incluido o LLP.ETA_LEM, ticket: 100-22724
--select * from tipo_carga
CREATE procedure [dbo].[spReservaPraca_Rel]--'EMATL201301026BR', 'N'
(
	@Processo as varchar(16),
	@CtaCte	as char(1)
)
AS
	select 
			HOU.Num_proc_hem         Processo,	
			Sh.Nome_Raz_Soc		 Shipper,
			CMC.Contato 		 ClienteCont,
			JOB.Nr_Reserva 		 Reserva,
			HOU.Navio_Hem		 Navio,
			HOU.Viagem_Hem		 Viagem,
			LLP.ETD_lem			ETD,
			LLP.ETA_lem			ETA,
			LDO.Nome_Local		 Origem,
			LDD.Nome_Local		 Destino,
			LDDF.Nome_local		 Destino_Final,
			CS.Nome_Raz_Soc		 Importador,
			dbo.fPO_Exp(@Processo,1) PO,
			dbo.fPO_Exp(@Processo,2) Invoce,
--			Mercadoria
--			Quantidade(Embalagem)
			HOU.Peso_Bruto_HEM	 Peso,
			OPER.Nome_Tp_Oper	 Tipo_Oper,
			HOU.Vol_Tot_HEM		 Volume,--Aparecer apenas se for LCL
			HOU.Tp_Frete_HEM	 Tipo_Frete,
			LLP.DL_Draft_Lem 	 Draft,
			LLP.DL_Cargo_Lem 	 Cargo,
			Doc.apelido 		 Docs,
			ENDD.Rua		 RuaDocs,
			ENDD.Numero		 NumeroDocs,
			ENDD.Compl_End		 ComplementoDocs,
			ENDD.CEP		 CEPDocs,
			ENDD.Bairro		 BairroDocs,
			ENDD.Cidade		 CidadeDocs,
			ENDD.UF			 UFDocs,
			ENDD.Pais		 PaisDocs,
			CMD.Contato 		 ContDocs,
			(CMD.Cd_Int + ' ' + CMD.Cd_area_fone + ' ' + CMD.Prefixo + ' ' + CMD.Num_fone) FoneDocs, 
			CMD.Compl_Fone		 EmailDocs,
			Crg.Apelido 		 Carga,
			ENDG.Rua		 RuaCarga,
			ENDG.Numero		 NumeroCarga,
			ENDG.Compl_End		 ComplementoCarga,
			ENDG.CEP		 CEPCarga,
			ENDG.Bairro		 BairroCarga,
			ENDG.Cidade		 CidadeCarga,
			ENDG.UF			 UFCarga,
			ENDG.Pais		 PaisCarga,
			CMG.Contato 		 ContCarga,
			(CMG.Cd_Int + ' ' + CMG.Cd_area_fone + ' ' + CMG.Prefixo + ' ' + CMG.Num_fone) FoneCarga, 
			CMG.Compl_Fone		 EmailCarga,
			FORW.Apelido 		 Forwarder,
			ENDF.Rua		 RuaForwarder,
			ENDF.Numero		 NumeroForwarder,
			ENDF.Compl_End		 ComplementoForwarder,
			ENDF.CEP		 CEPForwarder,
			ENDF.Bairro		 BairroForwarder,
			ENDF.Cidade		 CidadeForwarder,
			ENDF.UF			 UFForwarder,
			ENDF.Pais		 PaisForwarder,
			CMF.Contato 		 ContForwarder,
			(CMF.Cd_Int + ' ' + CMF.Cd_area_fone + ' ' + CMF.Prefixo + ' ' + CMF.Num_fone) FoneForwarder, 
			CMF.Compl_Fone		 EmailForwarder,
			HOU.TTime_d		 TTime_d,
			JOB.OBS_JEM 		 OBS,

			Descr.Descr 		Good_Descr,

			sum(VOL.Qtd_Vol_EM) Qtd_Vol,
			nome_tp_carga,
			LLP.DL_VGM_LEM DL_DGM
			
	From
		Job_Exp_Mar JOB with(nolock)
		Left Outer Join House_Exp_mar HOU with(nolock) on JOB.Num_proc_hem = HOU.num_proc_hem
		Left Outer Join Pessoa Sh with(nolock) on HOU.Cd_Export_Hem = Sh.Cd_pes
		Left Outer Join Pessoa CS with(nolock) on HOU.Cd_Consig_Hem = CS.Cd_Pes
		Left Outer Join Localidade LDO with(nolock) on HOU.Cd_Org_HEM = LDO.Cd_Local
		Left Outer Join Localidade LDD with(nolock) on HOU.Cd_Dst_HEM = LDD.Cd_Local
		Left Outer Join Tipo_Oper OPER with(nolock) on HOU.Cd_tp_Oper = OPER.Cd_tp_Oper
		Left Outer Join LLP_Exp_Mar LLP on JOB.Num_Proc_Hem = LLP.Num_Proc_Lem
		Left Outer Join Tipo_carga TP with(nolock) on TP.cd_tp_carga = LLP.cd_tp_carga
		Left Outer Join Localidade LDDF with(nolock) on LLP.Cd_DstFinal_Lem = LDDF.Cd_Local
		Left Outer Join Pessoa FORW with(nolock) on LLP.Cd_Forwarder = FORW.Cd_Pes
		Left Outer Join Comunicacao CMF with(nolock) on FORW.Cd_pes = CMF.cd_pes and cd_Tp_Com = 'TC1'
		Left Outer Join Endereco ENDF with(nolock) on FORW.cd_pes = ENDF.cd_pes and ENDF.cd_tp_end='COM'
		Left Outer Join Pessoa Cli with(nolock) on HOU.cd_export_hem = Cli.cd_pes
		Left Outer Join Comunicacao  CMC with(nolock) on Cli.cd_pes = CMC.cd_pes and JOB.cd_tp_com_cli = CMC.cd_tp_com
		Left Outer Join Pessoa Doc with(nolock) on JOB.Cd_Pes_Dcto = Doc.Cd_Pes
		Left Outer Join Endereco ENDD with(nolock) on Doc.cd_pes = ENDD.cd_pes and ENDD.cd_tp_end='COM'
		Left Outer Join Comunicacao CMD with(nolock) on Doc.cd_pes = CMD.cd_pes and JOB.Cd_Tp_Com_Dcto = CMD.Cd_Tp_Com
		Left Outer Join Pessoa Crg with(nolock) on JOB.Cd_Pes_Crg = Crg.cd_pes
		Left Outer Join Endereco ENDG with(nolock) on Crg.cd_pes = ENDG.cd_pes and ENDG.cd_tp_end='COM'
		Left Outer Join Comunicacao CMG with(nolock) on Crg.cd_pes = CMG.cd_pes and JOB.Cd_Tp_Com_Crg = CMG.Cd_Tp_Com
		Left Outer Join Nature_Goods Descr with(nolock) on HOU.Num_proc_hem = Descr.Num_Proc
		Left Outer Join Volume_Exp_Mar VOL with(nolock) on HOU.Num_proc_hem = VOL.Num_proc_hem
	where JOB.num_proc_hem = @Processo
Group by
HOU.Num_proc_hem,
Sh.Nome_Raz_Soc,
CMC.Contato ,
JOB.Nr_Reserva ,
HOU.Navio_Hem,
HOU.Viagem_Hem,
LLP.ETD_lem,
LLP.ETA_Lem,
LDO.Nome_Local,
LDD.Nome_Local,
LDDF.Nome_local,
CS.Nome_Raz_Soc,
--dbo.fPO_Exp(@Processo,1) PO,
--dbo.fPO_Exp(@Processo,2) Invoce,
--Mercadoria,
--Quantidade(Embalagem),
HOU.Peso_Bruto_HEM,
OPER.Nome_Tp_Oper,
HOU.Vol_Tot_HEM,
HOU.Tp_Frete_HEM,
LLP.DL_Draft_Lem ,
LLP.DL_Cargo_Lem ,
Doc.apelido ,
ENDD.Rua,
ENDD.Numero,
ENDD.Compl_End,
ENDD.CEP,
ENDD.Bairro,
ENDD.Cidade,
ENDD.UF,
ENDD.Pais,
CMD.Contato ,
CMD.Cd_Int, CMD.Cd_area_fone, CMD.Prefixo, CMD.Num_fone, 
CMD.Compl_Fone,
Crg.Apelido ,
ENDG.Rua,
ENDG.Numero,
ENDG.Compl_End,
ENDG.CEP,
ENDG.Bairro,
ENDG.Cidade,
ENDG.UF,
ENDG.Pais,
CMG.Contato ,
CMG.Cd_Int, CMG.Cd_area_fone,CMG.Prefixo,CMG.Num_fone, 
CMG.Compl_Fone,
FORW.Apelido ,
ENDF.Rua,
ENDF.Numero,
ENDF.Compl_End,
ENDF.CEP,
ENDF.Bairro,
ENDF.Cidade,
ENDF.UF,
ENDF.Pais,
CMF.Contato ,
CMF.Cd_Int, CMF.Cd_area_fone, CMF.Prefixo, CMF.Num_fone, 
CMF.Compl_Fone,
HOU.TTime_d,
JOB.OBS_JEM ,

Descr.Descr,
LLP.cd_tp_carga,
TP.cd_tp_carga,
TP.nome_tp_carga,
LLP.DL_VGM_LEM


GO
