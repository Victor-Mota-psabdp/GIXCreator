SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_NotaFiscalCanc_Rel] --'',2014,1
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status =2
	Join House_imp_mar hou with(nolock)  on hou.num_proc_him=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status =2
	Join Master_imp_mar MAs with(nolock)  on MAS.num_proc_Mim=cta.num_proc
	Join Pessoa CLI with(nolock)  on MAS.cd_consig_Mim=CLI.cd_pes
	left  Join Pessoa_LLP PLLP with(nolock)  on cd_consig_Mim=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
Where
	year(Dt_Fatura)=@Ano
	and month(Dt_Fatura)=@Mes
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status =2
	Join House_imp_AER hou with(nolock)  on hou.num_proc_HIA=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_HIA=CLI.cd_pes
	left  Join Pessoa_LLP PLLP with(nolock)  on cd_consig_HIA=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
Where
	year(Dt_Fatura)=@Ano
	and month(Dt_Fatura)=@Mes
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status =2
	Join Master_imp_AER MAs with(nolock)  on MAS.num_proc_MIA=cta.num_proc
	Join Pessoa CLI with(nolock)  on MAS.cd_consig_MIA=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_MIA=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
Where
	year(Dt_Fatura)=@Ano
	and month(Dt_Fatura)=@Mes
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status =2
	Join House_exp_mar hou with(nolock)  on hou.num_proc_hem=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_export_hem=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_hem=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
Where
	year(Dt_Fatura)=@Ano
	and month(Dt_Fatura)=@Mes
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status =2
	Join Master_exp_mar MAs with(nolock)  on MAS.num_proc_mem=cta.num_proc
	Join Pessoa CLI with(nolock)  on MAS.cd_export_mem=CLI.cd_pes
	left  Join Pessoa_LLP PLLP with(nolock)  on cd_export_mem=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
Where
	year(Dt_Fatura)=@Ano
	and month(Dt_Fatura)=@Mes
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status =2
	Join House_exp_aer hou with(nolock)  on hou.num_proc_hea=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_export_hea=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_hea=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
Where
	year(Dt_Fatura)=@Ano
	and month(Dt_Fatura)=@Mes
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status =2
	Join Master_exp_aer MAs with(nolock)  on MAS.num_proc_mea=cta.num_proc
	Join Pessoa CLI with(nolock)  on MAS.cd_export_mea=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_mea=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
Where
	year(Dt_Fatura)=@Ano
	and month(Dt_Fatura)=@Mes
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status =2
	Join House_exp_out hou with(nolock)  on hou.num_proc_heo=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_export_heo=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_heo=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
Where
	year(Dt_Fatura)=@Ano
	and month(Dt_Fatura)=@Mes
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status =2
	Join House_imp_out hou with(nolock)  on hou.num_proc_hio=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hio=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hio=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc
Where
	year(Dt_Fatura)=@Ano
	and month(Dt_Fatura)=@Mes
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
	NF.Dt_Cancel [Dt. Cancelamento],
	AXD.id_Ax [AX DOC]
from 
	Fatura_Arg_Det CTA  with(nolock)
	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status = 2
	Join House_BDP_OUT hou with(nolock)  on hou.Num_Proc_HBO=cta.num_proc
	Join Pessoa CLI with(nolock)  on HOU.cd_cliente_hbo=CLI.cd_pes
	left Join Pessoa_LLP PLLP with(nolock)  on cd_cliente_hbo=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Pessoa Dev with(nolock) on FAT.cd_PEs = Dev.cd_pes
	Join Base_Nota_Fiscal NF with(nolock) on FAT.Numero =NF.Nota_Fiscal  and FAT.Codigo = NF.Ref_Acesso
	join Site ST with(nolock) on FAT.Codigo =ST.Cd_Site
	Left Join dbo.vwAXDocs AXD with(nolock) on AXD.num_proc=CTA.num_proc and CTA.cd_Tp_Tx=AXD.cd_tp_Tx_ATL and AXD.dc=CTA.dc

Where
	year(Dt_Fatura)=@Ano
	and (month(Dt_Fatura)=@Mes or @Mes='')
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo = '')
	and CTA.cd_tp_Tx <> 'FRT'
	


GO
