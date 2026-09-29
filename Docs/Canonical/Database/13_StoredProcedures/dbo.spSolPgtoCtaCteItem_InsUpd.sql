SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spSolPgtoCtaCteItem_InsUpd]
	@ID	bigint,
	@ID_Item	int,
	@Num_Proc	varchar(16),
	@Cd_Tp_Tx	varchar(3),
	@DC			varchar(1),
	@Cd_Tp_Moeda	varchar(3),
	@Vlr_Ref	decimal(18,2),
	@Cd_Tp_Par	varchar(3),
	@Par_Moeda	decimal(18,4),
	@Vlr_Pgto_Rcto	decimal(18,2),
	@Master		varchar(14)
as

if @Cd_Tp_Moeda ='BRL'
	Begin
	set @Cd_Tp_Moeda = 'REL'
	End

if not exists(Select ID_ITEM from Sol_Pgto_Cta_Cte_Item where ID=@ID and Num_Proc = @Num_Proc and Cd_Tp_tx = @Cd_Tp_Tx and DC = @DC)

---if @ID_Item is NULL or @ID_Item = ''
	Begin
		Declare @New_ID_Item bigint
		Set @New_ID_Item = (Select ISNULL(max(ID_Item),0)+1 from Sol_Pgto_Cta_Cte_Item where ID=@ID)
		insert into 
					Sol_Pgto_Cta_Cte_Item
						(
						ID,
						ID_Item,
						Num_Proc,
						Cd_Tp_Tx,
						DC,
						Cd_Tp_Moeda,
						Vlr_Ref,
						Dt_Conv,
						Cd_Tp_Par,
						Par_Moeda,
						Vlr_Pgto_Rcto,
						Num_Proc_Master
						)
		values
						(
							@ID,
							@New_ID_Item,
							@Num_Proc,
							@Cd_Tp_Tx,
							@DC,
							@Cd_Tp_Moeda,
							@Vlr_Ref,
							GETDATE(),
							@Cd_Tp_Par,
							@Par_Moeda,
							@Vlr_Pgto_Rcto,
							@Master					
						)
	end
else
	Begin
		Update Sol_Pgto_Cta_Cte_Item 
						set
							Cd_Tp_Moeda = @Cd_Tp_Moeda,
							Vlr_Ref = @Vlr_Ref,
							Dt_Conv = getdate(),
							Cd_Tp_Par = @Cd_Tp_Par,
							Par_Moeda = @Par_Moeda,
							Vlr_Pgto_Rcto = @Vlr_Pgto_Rcto,
							Num_Proc_Master = @Master	
						where 
							ID=@ID and Num_Proc = @Num_Proc and Cd_Tp_tx = @Cd_Tp_Tx and DC = @DC
	End
GO
