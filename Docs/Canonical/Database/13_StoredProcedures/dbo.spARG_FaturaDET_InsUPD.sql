SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	Procedure [dbo].[spARG_FaturaDET_InsUPD] 
	@ID_Fat			int,
	@Num_Proc		varchar(16),
	@Taxa			varchar(50),
	@Moeda			varchar(30),
	@DC				char(1),
	@Valor_Org		float,
	@Paridade		float,
	@Valor_ARP		float,
	@Valor_IVA_ARP	float
AS

--BEGIN TRANSACTION
	Declare @Cd_Tp_Tx		varchar(3)
	Declare @Cd_Tp_Moeda	varchar(3)

	set @Cd_Tp_Tx = (select Cd_Tp_Tx from Tipo_Taxa with(nolock) where Nome_Tp_Tx = @Taxa)
	set @Cd_Tp_Moeda = (select Cd_Tp_Moeda from Tipo_moeda with(nolock) where Nome_Tp_Moeda = @Moeda)

	if not exists(select ID_Fat from Fatura_ARG_Det where ID_Fat=@ID_Fat and Num_Proc=@Num_Proc and Cd_Tp_Tx=@Cd_Tp_Tx and DC=@DC)
		BEGIN
			INSERT INTO
				Fatura_ARG_Det
				(
					ID_Fat,Num_Proc,Cd_Tp_Tx,Cd_tp_Moeda,DC,
					Valor_Org,Paridade,Valor_ARP,Valor_IVA_ARP
				)
				VALUES
				(
					@ID_Fat,@Num_Proc,@Cd_Tp_Tx,@Cd_tp_Moeda,@DC,
					@Valor_Org,@Paridade,@Valor_ARP,@Valor_IVA_ARP
				)
		END
	else
		BEGIN
			UPDATE
				Fatura_ARG_Det
			SET
				Valor_Org=@Valor_Org,Paridade=@Paridade,Valor_ARP=@Valor_ARP,Valor_IVA_ARP=@Valor_IVA_ARP
			WHERE
				ID_Fat=@ID_Fat and Num_Proc=@Num_Proc and Cd_Tp_Tx=@Cd_Tp_Tx and DC=@DC
		END
	
	--IF @@ERROR<>0 
	--	BEGIN
	--		ROLLBACK TRANSACTION
	--		RETURN -1
	--	END
--COMMIT TRANSACTION





GO
