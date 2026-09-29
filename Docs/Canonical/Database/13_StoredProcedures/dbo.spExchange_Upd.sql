SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spExchange_Upd]
		@Num_Proc	Varchar(16),
		@Tipo		Char(1)
AS

/*

	Tipos
		R = ReportManager
		X = BDPSmart
		V = ReportManagerV2

*/
Begin Transaction

	if @Tipo='R'
		Begin
		
			update exchange set excreportmanager=getdate() where excprocesso=@Num_PRoc and excreportmanager is null
		
		End

	if @Tipo='X'
		Begin

			--If  SUBSTRING(@Num_Proc,1,2) not in('IA','EA')
			--	Begin
			--		update exchange set excdtenvio=getdate() where excprocesso=@Num_PRoc and excdtenvio is null
			--	End
			--Else
			--	Begin
					update ATL_INT.dbo.Exchange_ODS set excdtenvio=getdate() where excprocesso=@Num_PRoc and excdtenvio is null
			--	End
		
		End

	if @Tipo='V'
		Begin
		
			update exchange set excreportmanager2=getdate() where excprocesso=@Num_PRoc and excreportmanager2 is null
		
		End

	if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction
GO
