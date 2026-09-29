SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Courier_InsUpd]
(
	@Num_Proc varchar(16),
	@Nome_Tp_Courier varchar(50),
	@Apelido varchar(20),
	@Num_Courier varchar(50),
	@Dt_Courier datetime
)
as

Declare	@ID bigint
Declare @ID_Item Int
Declare @ID_Tp_Courier int
Declare @Cd_Pes varchar(10)

Set @ID_Tp_Courier = (Select ID_Tp_Courier from Tipo_Courier where Nome_Tp_Courier = @Nome_Tp_Courier)
Set @Cd_Pes = (Select Cd_Pes from Pessoa where Apelido =  @Apelido)

if not Exists(Select ID from Courier_Processo where Num_Proc = @Num_Proc and ID_Tp_Courier = @ID_Tp_Courier and Cd_Pes = @Cd_Pes and Num_Courier = @Num_Courier )
	Begin
		Set @ID = (Select isnull(max(ID),0) +1 from Courier_Processo)
		Set @ID_Item = (Select isnull(max(ID_Item),0) +1 from Courier_Processo where Num_Proc = @Num_Proc)
		insert into Courier_Processo(
									ID,
									ID_Item,
									Num_Proc,
									ID_Tp_Courier,
									Cd_Pes,
									Num_Courier,
									Dt_Courier,
									Dt_Ins
									)
							Values(
									@ID,
									@ID_Item,
									@Num_Proc,
									@ID_Tp_Courier,
									@Cd_Pes,
									@Num_Courier,
									@Dt_Courier,
									getdate()
							)
	End
else
	Begin
		Update Courier_Processo set  Dt_Courier = @Dt_Courier,dt_ins=GETDATE() 
		where Num_Proc = @Num_Proc and ID_Tp_Courier = @ID_Tp_Courier and Cd_Pes = @Cd_Pes and Num_Courier = @Num_Courier 
	End
						
						


GO
