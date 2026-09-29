SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_FinancialSFDC_InsUpd] (
	@Num_Proc varchar(16),
	@IC bigint,
	@SFDCID varchar(16)
)
as


If not exists(select ID from Financial_SFDC where Num_Proc = @Num_Proc and IC = @IC)
Begin
	Insert 
		Financial_SFDC (
			Num_Proc,
			IC,
			SFDCID,
			Dt_Ins
		)
	values
	(
			@Num_Proc,
			@IC,
			@SFDCID,
			GETDATE()
	)
End
GO
