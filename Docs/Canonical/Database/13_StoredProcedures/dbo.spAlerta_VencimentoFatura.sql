SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	Procedure [dbo].[spAlerta_VencimentoFatura] --'CON'
(
@Grupo as varchar(3)
)
As
	select distinct
	HOU.Num_Proc_Him JOB,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_Him, 1) PO,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_Him, 5) DI,
	dbo.fBusca_CampoCliente(HOU.num_proc_him, 29) Vencimento,
	dbo.fBusca_PRODUTO(Hou.Num_Proc_him) Produto
from 
	house_imp_mar HOU	
where 
	right(left(HOU.num_proc_him, 5), 3) = @Grupo 
	and convert(datetime, left(getdate(), 12), 105) = convert(datetime, dbo.fBusca_CampoCliente(HOU.num_proc_him, '29'), 105) - 15

GO
