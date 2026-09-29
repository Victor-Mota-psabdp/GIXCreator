SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--alter table dbo.Exchange_JMD_AX_ATL add [Envio] [bit] NULL
--update dbo.Exchange_JMD_AX_ATL set Envio = 1
CREATE procedure [dbo].[spIntAXJMD_InsUpd] --spIntAXJMD_InsUpd ' IACSR201310030BR'
	
		@Num_Proc	Varchar(16)
	

as
Begin
	if not exists(select top 1 num_proc from dbo.Exchange_JMD_AX_ATL where num_proc=@Num_Proc)
		Begin
			Insert dbo.Exchange_JMD_AX_ATL
				(
					num_proc,dt_envio,dt_envio_Ax,Envio
				)
			Values
				(
					@num_proc,getdate(),getdate(),1
				)
		End
	Else
		Begin
			UPDATE 
				dbo.Exchange_JMD_AX_ATL 
			set 
				dt_envio_Ax = getdate(),
				Envio = 1
			where
				num_proc=@Num_Proc			
		End

	Begin
		Update dbo.Exchange set dt_envio_jmd_Ax=getdate() where excprocesso=@num_proc and dt_envio_jmd_Ax is null
	End
End

GO
