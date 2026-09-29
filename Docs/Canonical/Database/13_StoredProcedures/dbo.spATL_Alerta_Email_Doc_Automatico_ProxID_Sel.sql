SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_ProxID_Sel]
	@Tipo char(1) --H = House, M = Master
As

	declare @ProxID int
	declare @Stop int

	set @Stop = 1
	set @ProxID = 1

	If @Tipo = 'H'
		Begin
			while (@Stop <> 0)
				Begin
					if NOT exists(select top 1 id from Alerta_Email_Doc_Automatico where id = @ProxID)
						set @Stop = 0
					else
						set @ProxID = @ProxID + 1
				End
		End
	Else
		Begin
			while (@Stop <> 0)
				Begin
					if NOT exists(select top 1 id from Alerta_Email_Doc_Automatico where id = @ProxID)
						set @Stop = 0
					else
						set @ProxID = @ProxID + 1
				End
		End

	select @ProxID ProxID
GO
