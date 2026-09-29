SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[spATL_NotaFiscal_Oracle_Rel]'',2026,5
CREATE procedure [dbo].[spATL_NotaFiscal_Oracle_Rel]--'',2021,8
(

	@Grupo Varchar(50),
	@Ano int,
	@Mes int

)
as
--if @Mes = 0
--begin 
--	SET @MES = ''
--end

IF @Ano = 0
begin
	--set @Ano = 2014
	set @Ano = (select Year(getdate()))
end

If @Grupo is NULL
begin
	set @Grupo = ''
end


--Declare @Grupo Varchar(50),@Ano int,@Mes int
--set @Grupo = ''
--set @Ano = 2026
--set @Mes = 5


select distinct
	LEFT(CTA.NUM_PROC,2) Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)		[Grupo],
	HOU.Num_proc					[JOB],
	CLI.Apelido						[Cliente],
	month(CTA.Dt_Fatura)			[Mês],
	Dev.Num_CPF_CNPJ				[CNPJ], 
	DEV.apelido						[Company], 
	TT.Nome_Tp_Tx					[Taxa],
	CTA.DC as						[DC], 
	
	CTA.Valor_Org	as				[Valor],
	CTA.Paridade	as				[Paridade],
	CTA.cd_tp_Moeda as				[Moeda],	
	
	CTA.Valor_ARP	as				[Valor em Real],
	
	CTA.Numero + ' - ' + ST.Nome_Site [Site],
	CTA.Numero as					[Nota Fiscal], 
	NF.RPS_NFE						[NFe],
	CTA.Dt_Fatura					[Dt. Emissão], 
	NF.Prazo						[Dt. Venc. Fatura],
	AXD.id_Ax						[AX DOC],
	Nome_BDP_Produto				[BDP Product],
	HOU.Master						[Consol Ref.],
	U.Nome_Usuario					[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
	
from 
	[dbo].[vwFaturasValidasArg] CTA
	Join vwCliente_Alerta hou with(nolock)  on hou.num_proc=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_cliente=CLI.cd_pes
	Join Pessoa_LLP PLLP with(nolock)  on HOU.cd_cliente=PLLP.cd_pes
	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on CTA.Cd_Pes_FAT = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on CTA.Numero =NF.Nota_Fiscal  and CTA.Ref_Accesso_Arg = NF.Ref_Acesso
	join Site ST with(nolock) on CTA.Ref_Accesso_Arg =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
	Join Campo_Processo CP	  with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '143'
	Join BDP_Produto	 PRO  with(nolock) on CP.Campo_Dados = PRO.ID_PD
	Join Usuario		 U	  with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(CTA.Dt_Fatura)=@Ano
	and (month(CTA.Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'
	--and AXD.Invoice_Number in ('IMATN202603005BRA','IMATN202603005BRB')

union all

select distinct
	LEFT(CTA.NUM_PROC,2)  Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	MAS.Num_Proc_Master		[JOB],
	CLI.Apelido				[Cliente],
	month(CTA.Dt_Fatura)	[Mês],
	DEV.Num_CPF_CNPJ		[CNPJ], 
	DEV.apelido				[Company], 
	TT.Nome_Tp_Tx			[Taxa],
	CTA.DC as				[DC], 
	
	CTA.Valor_Org	as					[Valor],
	CTA.Paridade	as					[Paridade],
	CTA.cd_tp_Moeda as					[Moeda],	
	
	CTA.Valor_ARP	as					[Valor em Real],
	
	CTA.Numero + ' - ' + ST.Nome_Site	[Site],
	CTA.Numero as						[Nota Fiscal], 
	NF.RPS_NFE							[NFe],
	CTA.Dt_Fatura						[Dt. Emissão], 
	NF.Prazo							[Dt. Venc. Fatura],
	AXD.id_Ax							[AX DOC],
	NULL								[BDP Product],
	NULL								[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number					[invoice_number]
from 
	[dbo].[vwFaturasValidasArg] CTA
	--Fatura_Arg_Det CTA  with(nolock)
	--Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join vwMaster_ALL MAs with(nolock)  on MAS.Num_Proc_Master=cta.num_proc
	Join Pessoa CLI with(nolock)  on MAS.Cd_Client_Master=CLI.cd_pes
	left  Join Pessoa_LLP PLLP with(nolock)  on MAS.Cd_Client_Master=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on CTA.Cd_Pes_FAT = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on CTA.Numero =NF.Nota_Fiscal  and CTA.Ref_Accesso_Arg = NF.Ref_Acesso
	join Site ST with(nolock) on CTA.Ref_Accesso_Arg =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
	Join Usuario	   U	with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'

Order by 1







--select 
--	'IM' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)		[Grupo],
--	HOU.Num_proc_him				[JOB],
--	CLI.Apelido						[Cliente],
--	month(FAT.Dt_Fatura)			[Mês],
--	FAT.CUIT						[CNPJ], 
--	DEV.apelido						[Company], 
--	TT.Nome_Tp_Tx					[Taxa],
--	CTA.DC as						[DC], 
	
--	CTA.Valor_Org	as				[Valor],
--	CTA.Paridade	as				[Paridade],
--	CTA.cd_tp_Moeda as				[Moeda],	
	
--	CTA.Valor_ARP	as				[Valor em Real],
	
--	FAT.Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as					[Nota Fiscal], 
--	NF.RPS_NFE						[NFe],
--	FAT.Dt_Fatura					[Dt. Emissão], 
--	NF.Prazo						[Dt. Venc. Fatura],
--	AXD.id_Ax						[AX DOC],
--	Nome_BDP_Produto				[BDP Product],
--	HOU.Num_Proc_MIM				[Consol Ref.],
--	U.Nome_Usuario					[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
	
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_mar hou with(nolock)  on hou.num_proc_him=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
--	--Join LLP_imp_mar LLP with(nolock)  on LLP.num_proc_Lim=cta.num_proc and Cd_Tp_Carga <> 3
--	Left Join Campo_Processo CP	  with(nolock) on HOU.Num_Proc_HIM = CP.Num_Proc and CP.Id_Campo = '143'
--	Left Join BDP_Produto	 PRO  with(nolock) on CP.Campo_Dados = PRO.ID_PD
--	Left Join Usuario		 U	  with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '')
--	and CTA.cd_tp_Tx <> 'FRT'
	

--union all

--select 
--	'IM' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)  [Grupo],
--	MAS.Num_proc_mim [JOB],
--	CLI.Apelido [Cliente],
--	month(FAT.Dt_Fatura) [Mês],
--	FAT.CUIT [CNPJ], 
--	DEV.apelido[Company], 
--	TT.Nome_Tp_Tx [Taxa],
--	CTA.DC as [DC], 
	
--	CTA.Valor_Org	as [Valor],
--	CTA.Paridade	as [Paridade],
--	CTA.cd_tp_Moeda as [Moeda],	
	
--	CTA.Valor_ARP	as [Valor em Real],
	
--	--Valor_ARP as [Valor], 
--	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as NotaFiscal,
--	NF.RPS_NFE [NFe],
--	FAT.Dt_Fatura[Dt. Emissão], 
--	NF.Prazo [Dt. Venc. Fatura],
--	AXD.id_Ax [AX DOC],
--	NULL								[BDP Product],
--	NULL								[Consol Ref.],
--	U.Nome_Usuario						[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join Master_imp_mar MAs with(nolock)  on MAS.num_proc_Mim=cta.num_proc
--	Join Pessoa CLI with(nolock)  on MAS.cd_consig_Mim=CLI.cd_pes
--	left  Join Pessoa_LLP PLLP with(nolock)  on cd_consig_Mim=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
--	--Join LLP_Master LLP with(nolock)  on LLP.num_proc_Master=cta.num_proc and Cd_Tp_Carga <> 3
--	Left Join Usuario	   U	with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '')
--	and CTA.cd_tp_Tx <> 'FRT'
	

--Union ALL
-----IMPORTACAO AEREA

--select 
--	'IA' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)  [Grupo],
--	HOU.Num_proc_HIA [JOB],
--	CLI.Apelido [Cliente],
--	month(FAT.Dt_Fatura) [Mês],
--	FAT.CUIT [CNPJ], 
--	DEV.apelido[Company], 
--	TT.Nome_Tp_Tx [Taxa],
--	CTA.DC as [DC], 
	
--	CTA.Valor_Org	as [Valor],
--	CTA.Paridade	as [Paridade],
--	CTA.cd_tp_Moeda as [Moeda],	
	
--	CTA.Valor_ARP	as [Valor em Real],
	
--	--Valor_ARP as [Valor],
--	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as [Nota Fiscal], 
--	NF.RPS_NFE [NFe],
--	FAT.Dt_Fatura [Dt. Emissão], 
--	NF.Prazo [Dt. Venc. Fatura],
--	AXD.id_Ax [AX DOC],
--	Nome_BDP_Produto					[BDP Product],
--	HOU.Num_Proc_MIA					[Consol Ref.],
--	U.Nome_Usuario						[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_AER hou with(nolock)  on hou.num_proc_HIA=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_HIA=CLI.cd_pes
--	left  Join Pessoa_LLP PLLP with(nolock)  on cd_consig_HIA=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
--	Left Join Campo_Processo   CP	with(nolock) on HOU.Num_Proc_HIA = CP.Num_Proc and CP.Id_Campo = '143'
--	Left Hash Join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
--	Left Join Usuario		   U	with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '' )
--	and CTA.cd_tp_Tx <> 'FRT'
	

--union all

--select 
--	'IA' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)  [Grupo],
--	MAS.Num_proc_MIA [JOB],
--	CLI.Apelido [Cliente],
--	month(FAT.Dt_Fatura) [Mês],
--	FAT.CUIT [CNPJ], 
--	DEV.apelido[Company], 
--	TT.Nome_Tp_Tx [Taxa],
--	CTA.DC as [DC],
	
--	CTA.Valor_Org	as [Valor],
--	CTA.Paridade	as [Paridade],
--	CTA.cd_tp_Moeda as [Moeda],	
	
--	CTA.Valor_ARP	as [Valor em Real],
	 
--	--Valor_ARP as [Valor], 
--	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as NotaFiscal,
--	NF.RPS_NFE [NFe],
--	FAT.Dt_Fatura[Dt. Emissão], 
--	NF.Prazo [Dt. Venc. Fatura],
--	AXD.id_Ax [AX DOC],
--	NULL								[BDP Product],
--	NULL								[Consol Ref.],
--	U.Nome_Usuario						[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join Master_imp_AER MAs with(nolock)  on MAS.num_proc_MIA=cta.num_proc
--	Join Pessoa CLI with(nolock)  on MAS.cd_consig_MIA=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_MIA=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
--	--Join LLP_Master LLP with(nolock)  on LLP.num_proc_Master=cta.num_proc and Cd_Tp_Carga <> 3
--	Left Join Usuario		    U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '')
--	and CTA.cd_tp_Tx <> 'FRT'
	

----Exportação Maritima

--Union ALL

--select 
--	'EM' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)  [Grupo],
--	HOU.Num_proc_hem [JOB],
--	CLI.Apelido [Cliente],
--	month(FAT.Dt_Fatura) [Mês],
--	FAT.CUIT [CNPJ], 
--	DEV.apelido[Company], 
--	TT.Nome_Tp_Tx [Taxa],
--	CTA.DC as [DC], 
	
--	CTA.Valor_Org	as [Valor],
--	CTA.Paridade	as [Paridade],
--	CTA.cd_tp_Moeda as [Moeda],	
	
--	CTA.Valor_ARP	as [Valor em Real],
	
--	--Valor_ARP as [Valor],
--	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as [Nota Fiscal], 
--	NF.RPS_NFE [NFe],
--	FAT.Dt_Fatura [Dt. Emissão], 
--	NF.Prazo [Dt. Venc. Fatura],
--	AXD.id_Ax [AX DOC],
--	Nome_BDP_Produto					[BDP Product],
--	HOU.Num_Proc_MEM					[Consol Ref.],
--	U.Nome_Usuario						[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_mar hou with(nolock)  on hou.num_proc_hem=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_hem=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_hem=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
--	--	Join LLP_exp_mar LLP with(nolock)  on LLP.num_proc_Lem=cta.num_proc and Cd_Tp_Carga <> 3
--	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HEM = CP.Num_Proc and CP.Id_Campo = '143'
--	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
--	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '')
--	and CTA.cd_tp_Tx <> 'FRT'
	

--union all

--select 
--	'EM' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)  [Grupo],
--	MAS.Num_proc_mem [JOB],
--	CLI.Apelido [Cliente],
--	month(FAT.Dt_Fatura) [Mês],
--	FAT.CUIT [CNPJ], 
--	DEV.apelido[Company], 
--	TT.Nome_Tp_Tx [Taxa],
--	CTA.DC as [DC], 
	
--	CTA.Valor_Org	as [Valor],
--	CTA.Paridade	as [Paridade],
--	CTA.cd_tp_Moeda as [Moeda],	
	
--	CTA.Valor_ARP	as [Valor em Real],
	
--	--Valor_ARP as [Valor], 
--	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as NotaFiscal,
--	NF.RPS_NFE [NFe],
--	FAT.Dt_Fatura[Dt. Emissão], 
--	NF.Prazo [Dt. Venc. Fatura],
--	AXD.id_Ax [AX DOC],
--	NULL								[BDP Product],
--	NULL								[Consol Ref.],
--	U.Nome_Usuario						[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join Master_exp_mar MAs with(nolock)  on MAS.num_proc_mem=cta.num_proc
--	Join Pessoa CLI with(nolock)  on MAS.cd_export_mem=CLI.cd_pes
--	left  Join Pessoa_LLP PLLP with(nolock)  on cd_export_mem=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
--	--Join LLP_Master LLP with(nolock)  on LLP.num_proc_Master=cta.num_proc and Cd_Tp_Carga <> 3
--	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '')
--	and CTA.cd_tp_Tx <> 'FRT'
	

--Union ALL
----Expostação Aerea

--select 
--	'EA' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)  [Grupo],
--	HOU.Num_proc_hea [JOB],
--	CLI.Apelido [Cliente],
--	month(FAT.Dt_Fatura) [Mês],
--	FAT.CUIT [CNPJ], 
--	DEV.apelido[Company], 
--	TT.Nome_Tp_Tx [Taxa],
--	CTA.DC as [DC], 
	
--	CTA.Valor_Org	as [Valor],
--	CTA.Paridade	as [Paridade],
--	CTA.cd_tp_Moeda as [Moeda],	
	
--	CTA.Valor_ARP	as [Valor em Real],
--	--Valor_ARP as [Valor],
	
--	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as [Nota Fiscal], 
--	NF.RPS_NFE [NFe],
--	FAT.Dt_Fatura [Dt. Emissão], 
--	NF.Prazo [Dt. Venc. Fatura],
--	AXD.id_Ax [AX DOC],
--	Nome_BDP_Produto					[BDP Product],
--	HOU.Num_Proc_MEA					[Consol Ref.],
--	U.Nome_Usuario						[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_aer hou with(nolock)  on hou.num_proc_hea=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_hea=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_hea=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
--	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HEA = CP.Num_Proc and CP.Id_Campo = '143'
--	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
--	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '')
--	and CTA.cd_tp_Tx <> 'FRT'
	

--union all

--select 
--	'EA' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)  [Grupo],
--	MAS.Num_proc_mea [JOB],
--	CLI.Apelido [Cliente],
--	month(FAT.Dt_Fatura) [Mês],
--	FAT.CUIT [CNPJ], 
--	DEV.apelido[Company], 
--	TT.Nome_Tp_Tx [Taxa],
--	CTA.DC as [DC], 
	
--	CTA.Valor_Org	as [Valor],
--	CTA.Paridade	as [Paridade],
--	CTA.cd_tp_Moeda as [Moeda],	
	
--	CTA.Valor_ARP	as [Valor em Real],
	
--	--Valor_ARP as [Valor], 
--	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as NotaFiscal,
--	NF.RPS_NFE [NFe],
--	FAT.Dt_Fatura[Dt. Emissão], 
--	NF.Prazo [Dt. Venc. Fatura],
--	AXD.id_Ax [AX DOC],
--	NULL								[BDP Product],
--	NULL								[Consol Ref.],
--	U.Nome_Usuario						[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join Master_exp_aer MAs with(nolock)  on MAS.num_proc_mea=cta.num_proc
--	Join Pessoa CLI with(nolock)  on MAS.cd_export_mea=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_mea=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
--	--Join LLP_Master LLP with(nolock)  on LLP.num_proc_Master=cta.num_proc and Cd_Tp_Carga <> 3
--	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '')
--	and CTA.cd_tp_Tx <> 'FRT'
	

--Union ALL

---- Exportacao Outros
--select 
--	'EO' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)  [Grupo],
--	HOU.Num_proc_heo [JOB],
--	CLI.Apelido [Cliente],
--	month(FAT.Dt_Fatura) [Mês],
--	FAT.CUIT [CNPJ], 
--	DEV.apelido[Company], 
--	TT.Nome_Tp_Tx [Taxa],
--	CTA.DC as [DC], 
	
--	CTA.Valor_Org	as [Valor],
--	CTA.Paridade	as [Paridade],
--	CTA.cd_tp_Moeda as [Moeda],	
	
--	CTA.Valor_ARP	as [Valor em Real],
	
--	--Valor_ARP as [Valor],
--	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as [Nota Fiscal], 
--	NF.RPS_NFE [NFe],
--	FAT.Dt_Fatura [Dt. Emissão], 
--	NF.Prazo [Dt. Venc. Fatura],
--	AXD.id_Ax [AX DOC],
--	Nome_BDP_Produto					[BDP Product],
--	NULL								[Consol Ref.],
--	U.Nome_Usuario						[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_out hou with(nolock)  on hou.num_proc_heo=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_heo=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_heo=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod

--	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HEO = CP.Num_Proc and CP.Id_Campo = '143'
--	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
--	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '')
--	and CTA.cd_tp_Tx <> 'FRT'
	

--Union ALL
-----Importação Outros

--select 
--	'IO' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)  [Grupo],
--	HOU.Num_proc_hio [JOB],
--	CLI.Apelido [Cliente],
--	month(FAT.Dt_Fatura) [Mês],
--	FAT.CUIT [CNPJ], 
--	DEV.apelido[Company], 
--	TT.Nome_Tp_Tx [Taxa],
--	CTA.DC as [DC], 
	
--	CTA.Valor_Org	as [Valor],
--	CTA.Paridade	as [Paridade],
--	CTA.cd_tp_Moeda as [Moeda],	
	
--	CTA.Valor_ARP	as [Valor em Real],
	
--	--Valor_ARP as [Valor],
--	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as [Nota Fiscal], 
--	NF.RPS_NFE [NFe],
--	FAT.Dt_Fatura [Dt. Emissão], 
--	NF.Prazo [Dt. Venc. Fatura],
--	AXD.id_Ax [AX DOC],
--	Nome_BDP_Produto					[BDP Product],
--	NULL								[Consol Ref.],
--	U.Nome_Usuario						[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_out hou with(nolock)  on hou.num_proc_hio=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hio=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hio=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
--	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HIO = CP.Num_Proc and CP.Id_Campo = '143'
--	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
--	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '')
--	and CTA.cd_tp_Tx <> 'FRT'
	
	
--Union ALL
-----BDP Others

--select 
--	'BO' Modal ,
--	(Case when @Grupo ='GRUPO DOW' then
--		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
--		 else PP.Apelido end)  [Grupo],
--	HOU.Num_Proc_HBO [JOB],
--	CLI.Apelido [Cliente],
--	month(FAT.Dt_Fatura) [Mês],
--	FAT.CUIT [CNPJ], 
--	DEV.apelido[Company], 
--	TT.Nome_Tp_Tx [Taxa],
--	CTA.DC as [DC], 
	
--	CTA.Valor_Org	as [Valor],
--	CTA.Paridade	as [Paridade],
--	CTA.cd_tp_Moeda as [Moeda],	
	
--	CTA.Valor_ARP	as [Valor em Real],
	
--	--Valor_ARP as [Valor],
--	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
--	FAT.Numero as [Nota Fiscal], 
--	NF.RPS_NFE [NFe],
--	FAT.Dt_Fatura [Dt. Emissão], 
--	NF.Prazo [Dt. Venc. Fatura],
--	AXD.id_Ax [AX DOC],
--	Nome_BDP_Produto					[BDP Product],
--	NULL								[Consol Ref.],
--	U.Nome_Usuario						[Log Emitter NF]
--	,AXD.Invoice_Number				[invoice_number]
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_BDP_OUT hou with(nolock)  on hou.Num_Proc_HBO=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_cliente_hbo=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente_hbo=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
--	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
--	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
--	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
--	Join dbo.vwFaturas_NF_Fatura_Validas INV with(nolock) on AXD.num_proc=INV.num_proc and AXD.cd_tp_Tx_ATL=INV.cd_Tp_Tx and AXD.dc=INV.dc and AXD.Invoice_Number=INV.FatCod
--	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HBO = CP.Num_Proc and CP.Id_Campo = '143'
--	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
--	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
--Where
--	year(Dt_Fatura)=@Ano
--	and (month(Dt_Fatura)=@Mes or @Mes='')
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = '')
--	and CTA.cd_tp_Tx <> 'FRT'
	
	
--OPTION(HASH JOIN)



/*
ALTER procedure [dbo].[spATL_NotaFiscal_Oracle_Rel]--'',2021,8
(

	@Grupo Varchar(50),
	@Ano int,
	@Mes int

)
as
--if @Mes = 0
--begin 
--	SET @MES = ''
--end

IF @Ano = 0
begin
	--set @Ano = 2014
	set @Ano = (select Year(getdate()))
end

If @Grupo is NULL
begin
	set @Grupo = ''
end
--set @Grupo = ''
--set @Ano = 2014
--set @Mes = 1
---IMPORTACAO MARITIMA
select 
	'IM' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)		[Grupo],
	HOU.Num_proc_him				[JOB],
	CLI.Apelido						[Cliente],
	month(FAT.Dt_Fatura)			[Mês],
	FAT.CUIT						[CNPJ], 
	DEV.apelido						[Company], 
	TT.Nome_Tp_Tx					[Taxa],
	CTA.DC as						[DC], 
	
	CTA.Valor_Org	as				[Valor],
	CTA.Paridade	as				[Paridade],
	CTA.cd_tp_Moeda as				[Moeda],	
	
	CTA.Valor_ARP	as				[Valor em Real],
	
	FAT.Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as					[Nota Fiscal], 
	NF.RPS_NFE						[NFe],
	FAT.Dt_Fatura					[Dt. Emissão], 
	NF.Prazo						[Dt. Venc. Fatura],
	AXD.id_Ax						[AX DOC],
	Nome_BDP_Produto				[BDP Product],
	HOU.Num_Proc_MIM				[Consol Ref.],
	U.Nome_Usuario					[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
	
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_imp_mar hou with(nolock)  on hou.num_proc_him=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	--Join LLP_imp_mar LLP with(nolock)  on LLP.num_proc_Lim=cta.num_proc and Cd_Tp_Carga <> 3
	Left Join Campo_Processo CP	  with(nolock) on HOU.Num_Proc_HIM = CP.Num_Proc and CP.Id_Campo = '143'
	Left Join BDP_Produto	 PRO  with(nolock) on CP.Campo_Dados = PRO.ID_PD
	Left Join Usuario		 U	  with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'

union all

select 
	'IM' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	MAS.Num_proc_mim [JOB],
	CLI.Apelido [Cliente],
	month(FAT.Dt_Fatura) [Mês],
	FAT.CUIT [CNPJ], 
	DEV.apelido[Company], 
	TT.Nome_Tp_Tx [Taxa],
	CTA.DC as [DC], 
	
	CTA.Valor_Org	as [Valor],
	CTA.Paridade	as [Paridade],
	CTA.cd_tp_Moeda as [Moeda],	
	
	CTA.Valor_ARP	as [Valor em Real],
	
	--Valor_ARP as [Valor], 
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as NotaFiscal,
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura[Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	NULL								[BDP Product],
	NULL								[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join Master_imp_mar MAs with(nolock)  on MAS.num_proc_Mim=cta.num_proc
	Join Pessoa CLI with(nolock)  on MAS.cd_consig_Mim=CLI.cd_pes
	left  Join Pessoa_LLP PLLP with(nolock)  on cd_consig_Mim=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	--Join LLP_Master LLP with(nolock)  on LLP.num_proc_Master=cta.num_proc and Cd_Tp_Carga <> 3
	Left Join Usuario	   U	with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'

Union ALL
---IMPORTACAO AEREA

select 
	'IA' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	HOU.Num_proc_HIA [JOB],
	CLI.Apelido [Cliente],
	month(FAT.Dt_Fatura) [Mês],
	FAT.CUIT [CNPJ], 
	DEV.apelido[Company], 
	TT.Nome_Tp_Tx [Taxa],
	CTA.DC as [DC], 
	
	CTA.Valor_Org	as [Valor],
	CTA.Paridade	as [Paridade],
	CTA.cd_tp_Moeda as [Moeda],	
	
	CTA.Valor_ARP	as [Valor em Real],
	
	--Valor_ARP as [Valor],
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as [Nota Fiscal], 
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura [Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	Nome_BDP_Produto					[BDP Product],
	HOU.Num_Proc_MIA					[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_imp_AER hou with(nolock)  on hou.num_proc_HIA=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_HIA=CLI.cd_pes
	left  Join Pessoa_LLP PLLP with(nolock)  on cd_consig_HIA=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	Left Join Campo_Processo   CP	with(nolock) on HOU.Num_Proc_HIA = CP.Num_Proc and CP.Id_Campo = '143'
	Left Hash Join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
	Left Join Usuario		   U	with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '' )
	and CTA.cd_tp_Tx <> 'FRT'

union all

select 
	'IA' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	MAS.Num_proc_MIA [JOB],
	CLI.Apelido [Cliente],
	month(FAT.Dt_Fatura) [Mês],
	FAT.CUIT [CNPJ], 
	DEV.apelido[Company], 
	TT.Nome_Tp_Tx [Taxa],
	CTA.DC as [DC],
	
	CTA.Valor_Org	as [Valor],
	CTA.Paridade	as [Paridade],
	CTA.cd_tp_Moeda as [Moeda],	
	
	CTA.Valor_ARP	as [Valor em Real],
	 
	--Valor_ARP as [Valor], 
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as NotaFiscal,
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura[Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	NULL								[BDP Product],
	NULL								[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join Master_imp_AER MAs with(nolock)  on MAS.num_proc_MIA=cta.num_proc
	Join Pessoa CLI with(nolock)  on MAS.cd_consig_MIA=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_MIA=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	--Join LLP_Master LLP with(nolock)  on LLP.num_proc_Master=cta.num_proc and Cd_Tp_Carga <> 3
	Left Join Usuario		    U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'

--Exportação Maritima

Union ALL

select 
	'EM' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	HOU.Num_proc_hem [JOB],
	CLI.Apelido [Cliente],
	month(FAT.Dt_Fatura) [Mês],
	FAT.CUIT [CNPJ], 
	DEV.apelido[Company], 
	TT.Nome_Tp_Tx [Taxa],
	CTA.DC as [DC], 
	
	CTA.Valor_Org	as [Valor],
	CTA.Paridade	as [Paridade],
	CTA.cd_tp_Moeda as [Moeda],	
	
	CTA.Valor_ARP	as [Valor em Real],
	
	--Valor_ARP as [Valor],
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as [Nota Fiscal], 
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura [Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	Nome_BDP_Produto					[BDP Product],
	HOU.Num_Proc_MEM					[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_exp_mar hou with(nolock)  on hou.num_proc_hem=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_export_hem=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_hem=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	--	Join LLP_exp_mar LLP with(nolock)  on LLP.num_proc_Lem=cta.num_proc and Cd_Tp_Carga <> 3
	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HEM = CP.Num_Proc and CP.Id_Campo = '143'
	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'

union all

select 
	'EM' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	MAS.Num_proc_mem [JOB],
	CLI.Apelido [Cliente],
	month(FAT.Dt_Fatura) [Mês],
	FAT.CUIT [CNPJ], 
	DEV.apelido[Company], 
	TT.Nome_Tp_Tx [Taxa],
	CTA.DC as [DC], 
	
	CTA.Valor_Org	as [Valor],
	CTA.Paridade	as [Paridade],
	CTA.cd_tp_Moeda as [Moeda],	
	
	CTA.Valor_ARP	as [Valor em Real],
	
	--Valor_ARP as [Valor], 
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as NotaFiscal,
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura[Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	NULL								[BDP Product],
	NULL								[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join Master_exp_mar MAs with(nolock)  on MAS.num_proc_mem=cta.num_proc
	Join Pessoa CLI with(nolock)  on MAS.cd_export_mem=CLI.cd_pes
	left  Join Pessoa_LLP PLLP with(nolock)  on cd_export_mem=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	--Join LLP_Master LLP with(nolock)  on LLP.num_proc_Master=cta.num_proc and Cd_Tp_Carga <> 3
	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'

Union ALL
--Expostação Aerea

select 
	'EA' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	HOU.Num_proc_hea [JOB],
	CLI.Apelido [Cliente],
	month(FAT.Dt_Fatura) [Mês],
	FAT.CUIT [CNPJ], 
	DEV.apelido[Company], 
	TT.Nome_Tp_Tx [Taxa],
	CTA.DC as [DC], 
	
	CTA.Valor_Org	as [Valor],
	CTA.Paridade	as [Paridade],
	CTA.cd_tp_Moeda as [Moeda],	
	
	CTA.Valor_ARP	as [Valor em Real],
	--Valor_ARP as [Valor],
	
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as [Nota Fiscal], 
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura [Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	Nome_BDP_Produto					[BDP Product],
	HOU.Num_Proc_MEA					[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_exp_aer hou with(nolock)  on hou.num_proc_hea=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_export_hea=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_hea=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HEA = CP.Num_Proc and CP.Id_Campo = '143'
	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'

union all

select 
	'EA' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	MAS.Num_proc_mea [JOB],
	CLI.Apelido [Cliente],
	month(FAT.Dt_Fatura) [Mês],
	FAT.CUIT [CNPJ], 
	DEV.apelido[Company], 
	TT.Nome_Tp_Tx [Taxa],
	CTA.DC as [DC], 
	
	CTA.Valor_Org	as [Valor],
	CTA.Paridade	as [Paridade],
	CTA.cd_tp_Moeda as [Moeda],	
	
	CTA.Valor_ARP	as [Valor em Real],
	
	--Valor_ARP as [Valor], 
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as NotaFiscal,
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura[Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	NULL								[BDP Product],
	NULL								[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join Master_exp_aer MAs with(nolock)  on MAS.num_proc_mea=cta.num_proc
	Join Pessoa CLI with(nolock)  on MAS.cd_export_mea=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_mea=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	--Join LLP_Master LLP with(nolock)  on LLP.num_proc_Master=cta.num_proc and Cd_Tp_Carga <> 3
	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'

Union ALL

-- Exportacao Outros
select 
	'EO' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	HOU.Num_proc_heo [JOB],
	CLI.Apelido [Cliente],
	month(FAT.Dt_Fatura) [Mês],
	FAT.CUIT [CNPJ], 
	DEV.apelido[Company], 
	TT.Nome_Tp_Tx [Taxa],
	CTA.DC as [DC], 
	
	CTA.Valor_Org	as [Valor],
	CTA.Paridade	as [Paridade],
	CTA.cd_tp_Moeda as [Moeda],	
	
	CTA.Valor_ARP	as [Valor em Real],
	
	--Valor_ARP as [Valor],
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as [Nota Fiscal], 
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura [Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	Nome_BDP_Produto					[BDP Product],
	NULL								[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_exp_out hou with(nolock)  on hou.num_proc_heo=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_export_heo=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_heo=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HEO = CP.Num_Proc and CP.Id_Campo = '143'
	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'

Union ALL
---Importação Outros

select 
	'IO' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	HOU.Num_proc_hio [JOB],
	CLI.Apelido [Cliente],
	month(FAT.Dt_Fatura) [Mês],
	FAT.CUIT [CNPJ], 
	DEV.apelido[Company], 
	TT.Nome_Tp_Tx [Taxa],
	CTA.DC as [DC], 
	
	CTA.Valor_Org	as [Valor],
	CTA.Paridade	as [Paridade],
	CTA.cd_tp_Moeda as [Moeda],	
	
	CTA.Valor_ARP	as [Valor em Real],
	
	--Valor_ARP as [Valor],
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as [Nota Fiscal], 
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura [Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	Nome_BDP_Produto					[BDP Product],
	NULL								[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_imp_out hou with(nolock)  on hou.num_proc_hio=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hio=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hio=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HIO = CP.Num_Proc and CP.Id_Campo = '143'
	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'
	
Union ALL
---BDP Others

select 
	'BO' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	HOU.Num_Proc_HBO [JOB],
	CLI.Apelido [Cliente],
	month(FAT.Dt_Fatura) [Mês],
	FAT.CUIT [CNPJ], 
	DEV.apelido[Company], 
	TT.Nome_Tp_Tx [Taxa],
	CTA.DC as [DC], 
	
	CTA.Valor_Org	as [Valor],
	CTA.Paridade	as [Paridade],
	CTA.cd_tp_Moeda as [Moeda],	
	
	CTA.Valor_ARP	as [Valor em Real],
	
	--Valor_ARP as [Valor],
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as [Nota Fiscal], 
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura [Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	Nome_BDP_Produto					[BDP Product],
	NULL								[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	,AXD.Invoice_Number				[invoice_number]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
	Join House_BDP_OUT hou with(nolock)  on hou.Num_Proc_HBO=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_cliente_hbo=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente_hbo=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Join dbo.vwAXDocOracle AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HBO = CP.Num_Proc and CP.Id_Campo = '143'
	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'
	
OPTION(HASH JOIN)



*/



GO
