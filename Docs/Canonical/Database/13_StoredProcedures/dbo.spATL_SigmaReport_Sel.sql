SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_SigmaReport_Sel] --[spATL_SigmaReport_Sel] '2014-08-01','2015-02-28'

	@DataInicial datetime,
	@DataFinal datetime		

AS

Declare @Table Table
	(
		Data	Datetime,
		Cliente Varchar(100),
		Qtd_PO	Int,
		Qtd_DI_Aer	Int,
		Qtd_DI_Mar	Int,
		Qtd_DI_Rod	int,
		Qtd_LI	int,
		Qtd_LI_Sub int,
		Qtd_Job int,
		Localidade Varchar(40)
		
	)
	
Insert @Table (Data,Cliente,Qtd_Job,Localidade )

select CONVERT(Datetime,C.dt_criacao,103),apelido,COUNT(num_proc),Nome_Local  from vwCliente 	C
Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
Join House_Imp_Mar hou with(nolock) on hou.Num_Proc_HIM=num_proc
Join Localidade DST with(nolock) on Cd_Dst_HIM = Cd_Local 

Where CONVERT(datetime,C.dt_criacao,103) between @DataInicial and @DataInicial and LEFT(num_proc,1)='I'
group by CONVERT(Datetime,C.dt_criacao,103),Apelido 	,Nome_Local 

Union all

select CONVERT(Datetime,C.dt_criacao,103),apelido,COUNT(num_proc),Nome_Local  from vwCliente 	C
Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
Join House_Imp_Aer hou with(nolock) on hou.Num_Proc_HIA=num_proc
Join Localidade DST with(nolock) on Cd_Dst_HIA = Cd_Local 

Where CONVERT(datetime,C.dt_criacao,103) between @DataInicial and @DataInicial and LEFT(num_proc,1)='I'
group by CONVERT(Datetime,C.dt_criacao,103),Apelido 	,Nome_Local 

Union all

select CONVERT(Datetime,C.dt_criacao,103),apelido,COUNT(num_proc),Nome_Local  from vwCliente 	C
Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=num_proc
Join Localidade DST with(nolock) on Cd_Dst_HIO = Cd_Local 

Where CONVERT(datetime,C.dt_criacao,103) between @DataInicial and @DataInicial and LEFT(num_proc,1)='I'
group by CONVERT(Datetime,C.dt_criacao,103),Apelido 	,Nome_Local 


Insert @Table (Data,Cliente,Qtd_PO,Localidade)

Select   dt_pedido, Apelido,count(Dt_Pedido),Nome_Local  from Pedido_Ship PD with(nolock)
Join Pedido P with(nolock) on P.Cd_pedido = PD.Cd_Pedido 
Join Pessoa PP with(nolock) on pp.Cd_Pes=Cd_Grupo 
Join House_Imp_Mar hou with(nolock) on hou.Num_Proc_HIM=PD.num_proc
Join Localidade DST with(nolock) on Cd_Dst_HIM = Cd_Local 
where
	Dt_Pedido between @DataInicial and @DataFinal
group by Dt_Pedido,Apelido 	,Nome_Local 

Union all

Select   dt_pedido, Apelido,count(Dt_Pedido),Nome_Local  from Pedido_Ship PD with(nolock)
Join Pedido P with(nolock) on P.Cd_pedido = PD.Cd_Pedido 
Join Pessoa PP with(nolock) on pp.Cd_Pes=Cd_Grupo 
Join House_Imp_AER hou with(nolock) on hou.Num_Proc_HIA=PD.num_proc
Join Localidade DST with(nolock) on Cd_Dst_HIA = Cd_Local 
where
	Dt_Pedido between @DataInicial and @DataFinal
group by Dt_Pedido,Apelido 	,Nome_Local 

Union all


Select   dt_pedido, Apelido,count(Dt_Pedido),Nome_Local  from Pedido_Ship PD with(nolock)
Join Pedido P with(nolock) on P.Cd_pedido = PD.Cd_Pedido 
Join Pessoa PP with(nolock) on pp.Cd_Pes=Cd_Grupo 
Join House_Imp_Out hou with(nolock) on hou.Num_Proc_HIO=PD.num_proc
Join Localidade DST with(nolock) on Cd_Dst_HIO = Cd_Local 
where
	Dt_Pedido between @DataInicial and @DataFinal
group by Dt_Pedido,Apelido 	,Nome_Local 


Insert @Table (Data,Cliente,Qtd_DI_Aer,Localidade )

select DI.Data_PO_HIA,Apelido, COUNT(Numero_PO_HIA) ,Nome_Local  from PO_HIA DI
Join vwCliente C on C.num_proc = DI.num_proc_hia
Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
Join House_Imp_Aer hou on hou.Num_Proc_HIa=DI.Num_Proc_HIa 
Join Localidade DST on Cd_Dst_HIA = Cd_Local 
where ID_DC=5 and Data_PO_HIA between @DataInicial and @DataFinal
Group by
	DI.Data_PO_HIA,Apelido,Nome_Local 


Insert @Table (Data,Cliente,Qtd_DI_mar,Localidade )

select DI.Data_PO_HIM,Apelido, COUNT(Numero_PO_HIM),Nome_Local   from PO_HIM DI
Join vwCliente C on C.num_proc = DI.num_proc_hiM
Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
Join House_Imp_Mar hou on hou.Num_Proc_HIM=DI.Num_Proc_HIM 
Join Localidade DST on Cd_Dst_HIM = Cd_Local 
where ID_DC=5 and Data_PO_HIM between @DataInicial and @DataFinal
Group by
	DI.Data_PO_HIM,Apelido,Nome_Local 


Insert @Table (Data,Cliente,Qtd_DI_Rod,Localidade )

select DI.Data_PO_HIO,Apelido, COUNT(Numero_PO_HIO),Nome_Local   from PO_HIO  DI
Join vwCliente C on C.num_proc = DI.num_proc_hiO
Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
Join House_Imp_Out hou on hou.Num_Proc_HIO=DI.Num_Proc_HIO 
Join Localidade DST on Cd_Dst_HIO = Cd_Local 
where ID_DC=5 and Data_PO_HIO between @DataInicial and @DataFinal
Group by
	DI.Data_PO_HIO,Apelido,Nome_Local 

Insert @Table (Data,Cliente,Qtd_LI,Localidade)
select Dt_Solicitacao,Apelido, COUNT(SLI.num_proc),'Santos' from Solicitacao_LI SLI
Join vwCliente C on C.num_proc = SLI.num_proc 
Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
where Dt_Solicitacao  between @DataInicial and @DataFinal
and ID_Tipo_LI in (1,2,3,6)
Group by
	Dt_Solicitacao ,Apelido

Insert @Table (Data,Cliente,Qtd_LI_Sub,Localidade)
select Dt_Solicitacao,Apelido, COUNT(SLI.num_proc),'Santos' from Solicitacao_LI SLI
Join vwCliente C on C.num_proc = SLI.num_proc 
Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
where Dt_Solicitacao  between @DataInicial and @DataFinal
 and ID_Tipo_LI in (4)
Group by
	Dt_Solicitacao ,Apelido


select 
	Data,Cliente,Localidade,
	sum(ISNULL(qtd_po,0)) [Quantidade de POs],
	SUM(isnull(qtd_di_Aer,0)) [Quantidade de DIs Aéreas],
	SUM(isnull(qtd_di_mar,0)) [Quantidade de DIs  Marítimas],
	SUM(isnull(qtd_di_rod,0)) [Quantidade de DIs Rodoviárias],
	SUM(isnull(qtd_li,0))[Quantidade de Lis],
	SUM(isnull(qtd_li_sub,0)) [Quantidade de LIs  Sub],
	SUM(isnull(Qtd_Job,0)) [Quantidade Job]

 From @Table
group by DATA,Cliente ,Localidade 
order by DATA
GO
