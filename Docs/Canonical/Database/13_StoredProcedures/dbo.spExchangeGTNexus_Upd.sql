SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spExchangeGTNexus_Upd]
		@ID			bigint
		
AS
/*

	Tipos
		R = ReportManager
		X = BDPSmart
		V = ReportManagerV2
		G = GT-Nexus

*/
Begin Transaction


		
			update exchange_GTNexus set Dt_Send=getdate() where ID=@ID and Dt_Send is null



	if @@error <> 0
		Begin

			RollBack Transaction
			return 
		End

Commit Transaction
GO
