SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--26/05
--Week 22

CREATE	Procedure [dbo].[spInvoiceCliente_InsUPD] 

--Invoice_Cliente
	@Seq			int = Null,
	@Num_Invoice	varchar(30),
	@Data_invoice	Datetime,
	@Processo		varchar(16),
	@Cliente		varchar(20), --Buyer
	@Vlr_Seguro		float,
	@Status			varchar(10),
	@Obs_PL			varchar(2000),
	@Obs_INV		varchar(2000),
	@Remarks		Varchar(2000),
	@Customer_Bank	varchar(400),
	@Linguagem		varchar(3),
	@Vencimento		datetime,
	@Prazo			int,
	@Cd_Termo		int,
	@Pais			varchar(50),
	@ID_Inv			int	OUTPUT
AS

Declare @cd_Cliente	varchar(10)
Declare @cd_pais	varchar(2)

BEGIN TRANSACTION

	set @cd_pais = (select cd_pais from pais where nome_pais = @pais)

	set @cd_cliente = (select cd_pes from pessoa where apelido = @Cliente)
	
	set @Seq = (select ID_Inv from Invoice_Cliente where Num_Invoice=@Num_Invoice and cd_Cliente=@Cd_Cliente and Num_proc=@Processo)
	
	if @SEQ IS NULL
		BEGIN
			Set @SEQ =(select Isnull(max(ID_INV),0) from Invoice_Cliente)+1
			INSERT INTO
				Invoice_Cliente
				(
					ID_INV, Num_Invoice, Data_Invoice,
					Num_Proc, Cd_Cliente, Vlr_Seguro, Status, Obs_PL,Obs_INV,Re_Marks,Customer_Bank,Linguagem,Vencimento,Prazo,Cd_Termo,cd_pais
				)
				VALUES
				(
					@Seq, @Num_Invoice, @Data_Invoice, 
					@Processo, @Cd_Cliente, @Vlr_Seguro, @Status, @Obs_PL,@Obs_INV, @Remarks , @Customer_Bank,@Linguagem,@Vencimento,@Prazo,@Cd_Termo,@cd_pais
				)
		END
	else
		BEGIN
			UPDATE
				Invoice_Cliente
			SET
				Data_Invoice=@Data_invoice,
				Vlr_Seguro=@Vlr_Seguro,
				Status=@Status, Obs_PL=@Obs_PL,Obs_INV=@Obs_INV, Re_Marks=@Remarks,
				Customer_Bank=@Customer_Bank, Linguagem=@Linguagem, Vencimento=@Vencimento, Prazo=@Prazo, Cd_Termo=@Cd_Termo, cd_pais=@cd_pais
			WHERE
				ID_INV=@Seq and Num_Invoice=@Num_Invoice and cd_Cliente=@Cd_Cliente
		END
				
	set @ID_Inv = @SEQ
	
	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION












GO
