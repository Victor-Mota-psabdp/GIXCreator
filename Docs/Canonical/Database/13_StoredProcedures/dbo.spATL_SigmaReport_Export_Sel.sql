SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_SigmaReport_Export_Sel] --[spATL_SigmaReport_Export_Sel] '2015-01-01','2015-12-31'

	@DataInicial datetime,
	@DataFinal datetime	

AS

--Quantidade de RE 4	Quantidade de DDE 12

Declare @Table Table
	(
		Data	Datetime,
		Cliente Varchar(100),
		Qtd_RE	Int,
		Qtd_DDE	Int		
	)
	

Insert @Table (Data,Cliente,Qtd_RE)

select RE.Data_PO_HEM,Apelido, COUNT(Numero_PO_HEM)  from PO_HEM RE
Join vwCliente C on C.num_proc = RE.Num_Proc_HEM
Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
where ID_DC=4 and Data_PO_HEM between @DataInicial and @DataFinal
Group by
	RE.Data_PO_HEM,Apelido
union
select RE.Data_PO_HEA,Apelido, COUNT(Numero_PO_HEA)  from PO_HEA RE
	Join vwCliente C on C.num_proc = RE.Num_Proc_HEA
	Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
	Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
where ID_DC=4 and Data_PO_HEA between @DataInicial and @DataFinal
Group by
	RE.Data_PO_HEA,Apelido
union
select RE.Data_PO_HEO,Apelido, COUNT(Numero_PO_HEO)  from PO_HEO RE
	Join vwCliente C on C.num_proc = RE.Num_Proc_HEO
	Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
	Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
where ID_DC=4 and Data_PO_HEO between @DataInicial and @DataFinal
Group by
	RE.Data_PO_HEO,Apelido

Insert @Table (Data,Cliente,Qtd_DDE)
select DDE.Data_PO_HEM,Apelido, COUNT(Numero_PO_HEM)  from PO_HEM DDE
	Join vwCliente C on C.num_proc = DDE.Num_Proc_HEM
	Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
	Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
where ID_DC=12 and Data_PO_HEM between @DataInicial and @DataFinal
Group by
	DDE.Data_PO_HEM,Apelido
union
select DDE.Data_PO_HEA,Apelido, COUNT(Numero_PO_HEA)  from PO_HEA DDE
	Join vwCliente C on C.num_proc = DDE.Num_Proc_HEA
	Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
	Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
where ID_DC=12 and Data_PO_HEA between @DataInicial and @DataFinal
Group by
	DDE.Data_PO_HEA,Apelido
union
select DDE.Data_PO_HEO,Apelido, COUNT(Numero_PO_HEO)  from PO_HEO DDE
	Join vwCliente C on C.num_proc = DDE.Num_Proc_HEO
	Join Pessoa_LLP  PP on pp.Cd_Pes=cd_cliente 
	Join Pessoa GRP  on pp.Cd_Pes_Grupo = GRP.Cd_Pes 
where ID_DC=12 and Data_PO_HEO between @DataInicial and @DataFinal
Group by
	DDE.Data_PO_HEO,Apelido


select 
	Data,Cliente,
	sum(ISNULL(Qtd_RE,0)) [Quantidade de RE],
	SUM(isnull(Qtd_DDE,0)) [Quantidade de DDE]
 From @Table
 group by DATA,Cliente 
 order by DATA
GO
