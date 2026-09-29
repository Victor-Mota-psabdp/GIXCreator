SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spRecibo_Item_InsUpd]
	@ID				bigint,
	@ID_Item		int,	
	@Nome_Tp_Tx		varchar(50),
	@DC				varchar(1),
	@Nome_Tp_Moeda	varchar(30),
	@Vlr_Ref		decimal(18,2),
	@Par_Moeda		decimal(18,4),
	@Vlr_Ref_Total	decimal(18,2)
as

Declare @Cd_Tp_Tx as varchar(3)
Declare @Cd_Tp_Moeda as varchar(3)
set @Cd_Tp_Tx = (Select Cd_Tp_Tx from Tipo_Taxa where Nome_Tp_Tx =@Nome_Tp_Tx)
set @Cd_Tp_Moeda = (Select Cd_Tp_Moeda from  Tipo_Moeda where Nome_Tp_Moeda =@Nome_Tp_Moeda)

if not exists(Select ID_ITEM from Recibo_Item where ID=@ID and Cd_Tp_tx = @Cd_Tp_Tx and DC = @DC)
	Begin
		Declare @New_ID_Item bigint
		Set @New_ID_Item = (Select ISNULL(max(ID_Item),0)+1 from Recibo_Item where ID=@ID)
		insert into 
			Recibo_Item
			(
				ID,ID_Item,Cd_Tp_Tx,DC,Cd_Tp_Moeda,Vlr_Ref,Par_Moeda,Vlr_Ref_Total
			)
		values
			(
				@ID,@New_ID_Item,@Cd_Tp_Tx,@DC,@Cd_Tp_Moeda,@Vlr_Ref,@Par_Moeda,@Vlr_Ref_Total					
			)
	end
else
	Begin
		Update Recibo_Item 
		set
			Cd_Tp_Moeda = @Cd_Tp_Moeda,
			Vlr_Ref = @Vlr_Ref,			
			Par_Moeda = @Par_Moeda,
			Vlr_Ref_Total = @Vlr_Ref_Total
		where 
			ID=@ID and Cd_Tp_tx = @Cd_Tp_Tx and DC = @DC
	End
GO
