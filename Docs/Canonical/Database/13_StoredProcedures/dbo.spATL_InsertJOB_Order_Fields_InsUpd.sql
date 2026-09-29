SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[spATL_InsertJOB_Order_Fields_InsUpd]
(
	@Id								int,
	@Modal							VARCHAR(2),
	@Cd_Pes_Grupo					varchar(10),
	@Incoterm						BIT,
	@Currency						BIT,
	@Order_Value					BIT,
	@Status							BIT,
	@Cd_Usuario						VARCHAR(6),
	@dt_ins							DATETIME
)

AS

Begin Transaction

	If  exists (select Id from InsertJOB_Order_Fields where Id=@Id)
		Begin
			Update
				InsertJOB_Order_Fields
			Set
				Modal=@Modal,
				Cd_Pes_Grupo = 	@Cd_Pes_Grupo,
				Incoterm = @Incoterm,
				Currency = @Currency,
				Order_Value = @Order_Value,
				Status = @Status,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				Id=@Id
		End
	Else
		Begin
			Insert InsertJOB_Order_Fields
				(Modal,Cd_Pes_Grupo,Incoterm,Currency,Order_Value,Status,Cd_Usuario,dt_ins)
			Values
				(@Modal,@Cd_Pes_Grupo,@Incoterm,@Currency,@Order_Value,@Status,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
