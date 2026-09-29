SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_SynchroExp_Rel]
	@DataInicial	Datetime,
	@DataFinal		Datetime
as


Select 
	num_proc_lem [BDP Ref.],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Lem,3) [Numero da Ordem],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Lem,1) [Numero da PO],
	Upper(Nome_Raz_SOc) [Razao Social],
	Num_CPF_CNPJ [CNPJ],
	Upper(cidade) [Cidade],
	UF ,
	right('00000'+ Numero_PO_HeM,8) [Nota Fiscal],
	Data_PO_HEM [Data NF],
	Isnull(HAWB_HEM,MAWB_HEM) [Conhecimento Transporte],
	Isnull(Dt_BL_LEM,ATD_LEM) [Data do Conhecimento de Transporte],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Lem,4) [Numero RE],
	cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lem,4) as datetime) [Data RE],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Lem,12) [Numero DDE],
	cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lem,12) as datetime) [Data DDE],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Lem,26) [Numero DSE],
	cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Lem,26) as datetime) [Data DSE],
	dbo.fBusca_Tarefa(num_proc_lem,15) [Data de Averbacao],
	case 
		when dbo.fBusca_TipoDocCliente('D',Num_Proc_Lem,12) is null then 'SIM'
		else 'NÃO'
	End IND_DECL_SIMPL ,
	case
		when dbo.fBusca_Tarefa(num_proc_lem,15) is not null then 'SIM'
		else 'NÃO'
	End DESPACHO_EXP 
	
	
FRom House_Exp_mar  Hou with(nolock)
Join Pessoa			PP  with(nolock) on PP.cd_pes=cd_Export_hem
Join LLP_Exp_mar    LLP with(nolock) on Num_proc_Lem = hou.num_proc_hem
Join Po_HEM			NF  with(nolock) on hou.num_proc_hem=NF.num_proc_hem and id_dc=10
Join Endereco		ED  with(nolock) on ED.cd_pes=cd_export_hem and ED.cd_tp_End='COM'
Where
	year(etd_lem)=year(getdate()-6) and month(etd_lem)=month(getdate()-6)
	and substring(num_proc_lem,3,3)in ('CSR','ROB','STB')
	and id_status <> 9

Union all


Select 
	num_proc_lea [BDP Ref.],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,3) [Numero da Ordem],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Lea,1) [Numero da PO],
	Upper(Nome_Raz_SOc) [Razao Social],
	Num_CPF_CNPJ [CNPJ],
	Upper(cidade) [Cidade],
	UF ,
	right('00000'+ Numero_PO_HeA,8) [Nota Fiscal],
	Data_PO_HEa [Data NF],
	Isnull(HAWB_HEa,MAWB_HEa) [Conhecimento Transporte],
	ATD_LEA [Data do Conhecimento de Transporte],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_LeA,4) [Numero RE],
	cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_LeA,4) as datetime) [Data RE],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_LeA,12) [Numero DDE],
	cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_LeA,12) as datetime) [Data DDE],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_LeA,26) [Numero DSE],
	cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_LeA,26) as datetime) [Data DSE],
	dbo.fBusca_Tarefa(num_proc_leA,15) [Data de Averbacao],
	case 
		when dbo.fBusca_TipoDocCliente('D',Num_Proc_Lea,12) is null then 'SIM'
		else 'NÃO'
	End IND_DECL_SIMPL ,
	case
		when dbo.fBusca_Tarefa(num_proc_lea,15) is not null then 'SIM'
		else 'NÃO'
	End DESPACHO_EXP 
FRom House_Exp_Aer  Hou with(nolock)
Join Pessoa			PP	with(nolock) on PP.cd_pes=cd_Export_hea
Join LLP_Exp_aer	LLP with(nolock) on Num_proc_Lea = hou.num_proc_hea
Join Po_HEA			NF  with(nolock) on hou.num_proc_heA=NF.num_proc_hea and id_dc=10
Join Endereco		ED  with(nolock) on ED.cd_pes=cd_export_heA and ED.cd_tp_End='COM'
Where
	year(etd_lea)=year(getdate()-6) and month(etd_lea)=month(getdate()-6)
	and substring(num_proc_lea,3,3)in ('CSR','ROB','STB')
	and id_status <> 9


Union all


Select 
	num_proc_leo [BDP Ref.],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,3) [Numero da Ordem],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,1) [Numero da PO],
	Upper(Nome_Raz_SOc) [Razao Social],
	Num_CPF_CNPJ [CNPJ],
	Upper(cidade) [Cidade],
	UF ,
	right('00000'+ Numero_PO_Heo,8) [Nota Fiscal],
	Data_PO_HEO [Data NF],
	Isnull(HAWB_HEo,MAWB_HEo) [Conhecimento Transporte],
	ATD_LEO [Data do Conhecimento de Transporte],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,4) [Numero RE],
	cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Leo,4) as datetime) [Data RE],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,12) [Numero DDE],
	cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Leo,12) as datetime) [Data DDE],
	dbo.fBusca_TipoDocCliente('N',Num_Proc_Leo,26) [Numero DSE],
	cast(dbo.fBusca_TipoDocCliente('D',Num_Proc_Leo,26) as datetime) [Data DSE],
	dbo.fBusca_Tarefa(num_proc_leo,15) [Data de Averbacao],
	case 
		when dbo.fBusca_TipoDocCliente('D',Num_Proc_Leo,12) is null then 'SIM'
		else 'NÃO'
	End IND_DECL_SIMPL ,
	case
		when dbo.fBusca_Tarefa(num_proc_leo,15) is not null then 'SIM'
		else 'NÃO'
	End DESPACHO_EXP 
FRom House_Exp_Out	Hou with(nolock)
Join Pessoa			PP  with(nolock) on PP.cd_pes=cd_Export_heo
Join LLP_Exp_out	LLP with(nolock)  on Num_proc_Leo = hou.num_proc_heo
Join Po_HEO			NF  with(nolock) on hou.num_proc_heo=NF.num_proc_heo and id_dc=10
Join Endereco		ED  with(nolock) on ED.cd_pes=cd_export_heo and ED.cd_tp_End='COM'
Where
	year(etd_leo)=year(getdate()-6) and month(etd_leo)=month(getdate()-6)
	and substring(num_proc_leo,3,3)in ('CSR','ROB','STB')
	and id_status <> 9



--select * from tipo_doc_cliente

GO
