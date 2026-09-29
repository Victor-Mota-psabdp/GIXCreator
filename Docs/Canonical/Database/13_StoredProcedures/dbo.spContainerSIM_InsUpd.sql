SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE      procedure spContainerSIM_InsUpd
			
	@Num_Proc_SIM 	VarChar(16),
	@Item_Cont 	int,
	@Container 	Varchar(30),
	@Qtd_SIM 	int,
	@Ativo		char(1)

AS
BEGIN TRANSACTION

Declare @ID Int
Declare @Cd_Tp_Cont Varchar(3)

	Set @Cd_Tp_Cont=(select Cd_Tp_Cont from Tipo_Container where nome_tp_cont=@Container)

	if @Item_Cont is not null
		BEGIN
			UPDATE
				Container_SIM
			SET
				Cd_Tp_Cont 	= @Cd_Tp_Cont,
				Qtd_SIM 	= @Qtd_SIM,
				Ativo		= @Ativo
			WHERE
				Item_Cont = @Item_Cont and Num_Proc_SIM = @Num_Proc_SIM
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(Item_Cont),0)+1 from Container_SIM where Num_Proc_SIM=@Num_Proc_SIM )
			INSERT INTO
				Container_SIM
				(
					Num_Proc_SIM,
					Item_Cont,	
					Cd_Tp_Cont,
					Qtd_SIM,
					Ativo
				)
			VALUES
				(
					@Num_Proc_SIM,
					@Id,
					@Cd_Tp_Cont,
					@Qtd_SIM,
					@Ativo
				)
		END
COMMIT TRANSACTION





GO
