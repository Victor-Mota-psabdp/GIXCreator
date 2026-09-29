SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spNF_Fatura_Item_InsUPD] 
	@ID				int,
	@Num_Proc		varchar(16),
	@Taxa			varchar(50),
	@Moeda			varchar(30),
	@DC				char(1),
	@Vlr_Org		float,
	@Paridade		float,
	@Vlr_RS			float,
	@Vlr_IVA		float,
	@Nota_Fiscal		varchar(8),
	@Ref_Acesso		char(1),
	@ONF		char(1),
	@RTX		char(1)

AS

BEGIN TRANSACTION
	Declare @Cd_Tp_Tx		varchar(3)
	Declare @Cd_Tp_Moeda	varchar(3)

	set @Cd_Tp_Tx = (select Cd_Tp_Tx from Tipo_Taxa where Nome_Tp_Tx = @Taxa)
	set @Cd_Tp_Moeda = (select Cd_Tp_Moeda from Tipo_moeda where Nome_Tp_Moeda = @Moeda)

	if not exists(select ID from NF_Fatura_Item where ID=@ID and Num_Proc=@Num_Proc and Cd_Tp_Tx=@Cd_Tp_Tx and DC=@DC)
		BEGIN
			INSERT INTO
				NF_Fatura_Item
				(
					ID,Num_Proc,Cd_Tp_Tx,DC,Cd_tp_Moeda,
					Vlr_Org,Paridade,Vlr_RS,Vlr_IVA,Nota_Fiscal,Ref_Acesso,
					ONF,RTX
				)
				VALUES
				(
					@ID,@Num_Proc,@Cd_Tp_Tx,@DC,@Cd_tp_Moeda,
					@Vlr_Org,@Paridade,@Vlr_RS,@Vlr_IVA	,@Nota_Fiscal,@Ref_Acesso,
					@ONF,@RTX			
				)
		END
	else
		BEGIN
			UPDATE
				NF_Fatura_Item
			SET
				Vlr_Org=@Vlr_Org,Paridade=@Paridade,Vlr_RS=@Vlr_RS,Vlr_IVA=@Vlr_IVA,Nota_Fiscal=@Nota_Fiscal,Ref_Acesso=@Ref_Acesso,
				ONF=@ONF,RTX=@RTX	
			WHERE
				ID=@ID and Num_Proc=@Num_Proc and Cd_Tp_Tx=@Cd_Tp_Tx and DC=@DC
		END
	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION





GO
