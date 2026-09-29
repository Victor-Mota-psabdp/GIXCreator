SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_NotaFiscal_DOW_Rel]--'',2015,6
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
	set @Ano = 2014
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
		 else PP.Apelido end)  [Grupo],
	HOU.Num_proc_him [JOB],

	-- Alessandra 16/07/2021
	REPLACE(dbo.fBusca_PO_NumPedido(HOU.Num_proc_him ,'PO'),';',' -')					AS [PO],
	[dbo].[fBusca_UoM_ALL](HOU.Num_proc_him,'UOM')					AS [UoM],
	DBO.fBusca_GrossWeight_ALL(HOU.Num_proc_him,'Gross Weight')		[Gross Weight],
	DBO.fBusca_Qty_ALL(HOU.Num_proc_him,'Qty')						[Qty],


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
	
	FAT. Codigo + ' - ' + ST.Nome_Site [Site],
	FAT.Numero as [Nota Fiscal], 
	NF.RPS_NFE [NFe],
	FAT.Dt_Fatura [Dt. Emissão], 
	NF.Prazo [Dt. Venc. Fatura],
	AXD.id_Ax [AX DOC],
	Nome_BDP_Produto					[BDP Product],
	HOU.Num_Proc_MIM					[Consol Ref.],
	U.Nome_Usuario						[Log Emitter NF]
	
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
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
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


Union ALL
---IMPORTACAO AEREA

select 
	'IA' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	HOU.Num_proc_HIA [JOB],

	-- Alessandra 16/07/2021
	REPLACE(dbo.fBusca_PO_NumPedido(HOU.Num_proc_HIA ,'PO'),';',' -')					AS [PO],
	[dbo].[fBusca_UoM_ALL](HOU.Num_proc_HIA,'UOM')					AS [UoM],
	DBO.fBusca_GrossWeight_ALL(HOU.Num_proc_HIA,'Gross Weight')		[Gross Weight],
	DBO.fBusca_Qty_ALL(HOU.Num_proc_HIA,'Qty')						[Qty],

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
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	Left Join Campo_Processo   CP	with(nolock) on HOU.Num_Proc_HIA = CP.Num_Proc and CP.Id_Campo = '143'
	Left Hash Join BDP_Produto PRO	with(nolock) on CP.Campo_Dados = PRO.ID_PD
	Left Join Usuario		   U	with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '' )
	and CTA.cd_tp_Tx <> 'FRT'


--Exportação Maritima

Union ALL

select 
	'EM' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	HOU.Num_proc_hem [JOB],

	-- Alessandra 16/07/2021
	REPLACE(dbo.fBusca_PO_NumPedido(HOU.Num_proc_hem ,'PO'),';',' -')					AS [PO],
	[dbo].[fBusca_UoM_ALL](HOU.Num_proc_hem,'UOM')					AS [UoM],
	DBO.fBusca_GrossWeight_ALL(HOU.Num_proc_hem,'Gross Weight')		[Gross Weight],
	DBO.fBusca_Qty_ALL(HOU.Num_proc_hem,'Qty')						[Qty],

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
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
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



Union ALL
--Expostação Aerea

select 
	'EA' Modal ,
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		 else PP.Apelido end)  [Grupo],
	HOU.Num_proc_hea [JOB],

	-- Alessandra 16/07/2021
	REPLACE(dbo.fBusca_PO_NumPedido(HOU.Num_proc_hea ,'PO'),';',' -')					AS [PO],
	[dbo].[fBusca_UoM_ALL](HOU.Num_proc_hea,'UOM')					AS [UoM],
	DBO.fBusca_GrossWeight_ALL(HOU.Num_proc_hea,'Gross Weight')		[Gross Weight],
	DBO.fBusca_Qty_ALL(HOU.Num_proc_hea,'Qty')						[Qty],

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
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HEA = CP.Num_Proc and CP.Id_Campo = '143'
	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
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

	-- Alessandra 16/07/2021
	REPLACE(dbo.fBusca_PO_NumPedido(HOU.Num_proc_heo ,'PO'),';',' -')					AS [PO],
	[dbo].[fBusca_UoM_ALL](HOU.Num_proc_heo,'UOM')					AS [UoM],
	DBO.fBusca_GrossWeight_ALL(HOU.Num_proc_heo,'Gross Weight')		[Gross Weight],
	DBO.fBusca_Qty_ALL(HOU.Num_proc_heo,'Qty')						[Qty],

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
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
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

	-- Alessandra 16/07/2021
	REPLACE(dbo.fBusca_PO_NumPedido(HOU.Num_proc_hio ,'PO'),';',' -')					AS [PO],
	[dbo].[fBusca_UoM_ALL](HOU.Num_proc_hio,'UOM')					AS [UoM],
	DBO.fBusca_GrossWeight_ALL(HOU.Num_proc_hio,'Gross Weight')		[Gross Weight],
	DBO.fBusca_Qty_ALL(HOU.Num_proc_hio,'Qty')						[Qty],

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
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
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

	-- Alessandra 16/07/2021
	REPLACE(dbo.fBusca_PO_NumPedido(JOB_HBO.Num_Proc ,'PO'),';',' -') AS [PO],
	[dbo].[fBusca_UoM_ALL](JOB_HBO.Num_Proc,'UOM') AS [UoM],
	DBO.fBusca_GrossWeight_ALL(JOB_HBO.Num_Proc,'Gross Weight')		[Gross Weight],
	DBO.fBusca_Qty_ALL(JOB_HBO.Num_Proc,'Qty')						[Qty],

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
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
	Left Join Campo_Processo	CP	 with(nolock) on HOU.Num_Proc_HBO = CP.Num_Proc and CP.Id_Campo = '143'
	Left Join BDP_Produto		PRO	 with(nolock) on CP.Campo_Dados = PRO.ID_PD
	Left Join Usuario			U	 with(nolock) on NF.Cd_Usuario = U.Cd_Usuario
	left join JOB_HBO (NOLOCK) ON JOB_HBO.Num_Proc_HBO = hou.Num_Proc_HBO
Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'
	
OPTION(HASH JOIN)




GO
