SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_FaturaCHB_Status_Sel]
		@FatCod Varchar(17)

AS
select status_pc from fatura_chb where fatura_pc=@FatCod
and status_pc= 'C'
	
GO
