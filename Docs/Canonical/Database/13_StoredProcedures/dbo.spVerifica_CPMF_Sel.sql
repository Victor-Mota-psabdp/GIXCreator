SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spVerifica_CPMF_Sel]
		(
		  @Nome_Tp_tx Varchar(100)
)

AS
select isnull(CPMF_TX,'N') Isento 
	from tipo_Taxa 
where nome_tp_tx=@Nome_Tp_tx


GO
