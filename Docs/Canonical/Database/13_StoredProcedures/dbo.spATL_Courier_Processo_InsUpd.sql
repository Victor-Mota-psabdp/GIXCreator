SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Courier_Processo
CREATE procedure [dbo].[spATL_Courier_Processo_InsUpd]
(
	@ID				Int,
	@ID_Item		Int,
	@Num_Proc		varchar(16),
	@ID_Tp_Courier	Int,
	@Cd_Pes			varchar(10),
	@Num_Courier	varchar(50),
	@Dt_Courier		datetime,
	@Cd_Usuario		varchar(10),
	@Dt_Ins			datetime
	
)
as

--Declare	@ID bigint
--Declare @ID_Item Int

if not Exists(Select ID from Courier_Processo where Num_Proc = @Num_Proc 
	and ID_Tp_Courier = @ID_Tp_Courier and Cd_Pes = @Cd_Pes and Num_Courier = @Num_Courier)
	Begin
		Set @ID = (Select isnull(max(ID),0) +1 from Courier_Processo)
		Set @ID_Item = (Select isnull(max(ID_Item),0) +1 from Courier_Processo where Num_Proc = @Num_Proc)
		insert into Courier_Processo
		(
			ID,ID_Item,Num_Proc,ID_Tp_Courier,Cd_Pes,Num_Courier,Dt_Courier,Dt_Ins,Cd_Usuario
		)
	Values
		(
			@ID,@ID_Item,@Num_Proc,@ID_Tp_Courier,@Cd_Pes,@Num_Courier,@Dt_Courier,getdate(),@Cd_Usuario
		)
	End
else
	Begin
		Update Courier_Processo 
			set  
				Dt_Courier = @Dt_Courier,
				dt_ins=GETDATE(),
				Cd_Usuario =@Cd_Usuario
		where 
			Num_Proc = @Num_Proc 
			and ID_Tp_Courier = @ID_Tp_Courier 
			and Cd_Pes = @Cd_Pes 
			and Num_Courier = @Num_Courier 
	End	

GO
