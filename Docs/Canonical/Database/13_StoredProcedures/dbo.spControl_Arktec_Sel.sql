SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Lindenberg, Rafael>
-- Create date: <03/10/2017>
-- Alter date:	<>
-- Description:	<Relatório de Controle Arktec - Ticket #100-74109>
-- =============================================

CREATE PROCEDURE  [dbo].[spControl_Arktec_Sel] --[spControl_Arktec_Sel] 'DOWP0000801'

	@Arktec_Num varchar(50)
	
AS

select distinct
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'30') [CAIXA ARKTEC],
HOU.Num_Proc [REFERÊNCIA],
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')	[PO],
dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'30')	[DATA],
(Case when dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'4') is Not null then (select dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'4')) 
	Else
		(Case when dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'4') IS NULL then 'N/A' 
			End)End)	[NÚMERO RE],
(Case when dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'26') is Not null then (select dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'26')) 
	Else
	(Case when dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'26') IS NULL then 'N/A' 
		End)End)	[DSE]
from vwHouse_Exp HOU with(nolock)
join vwPO_Exp PO with(nolock) on HOU.Num_Proc = PO.Num_Proc
where PO.Arktec_Num = @Arktec_Num
GO
