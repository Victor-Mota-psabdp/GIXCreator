SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	Procedure [dbo].[spNF_viaXML_Ins]

	@CNPJ		Varchar(15),
	@Nota_Fiscal	Varchar(20),
	@Emissao	datetime,
	@CFOP		Varchar(10),
	@Invoice	Varchar(30),
	@Cd_Exportador	Varchar(20),
	@Vlr_NF		float,
	@Complementar	char(1),
	@ID_NF_FK	int,
	@DI		Varchar(25),
	@Data_DI	datetime,
	@Paridade	float,
	@Num_Proc	Varchar(16),
	@ID_NF_N	int OUTPUT
AS
Begin Transaction

	Declare	@Cd_Cliente	Varchar(10)
	Declare @Cd_Vendor	Varchar(10)
	Declare	@ID_NF		int

	Set @Cd_Cliente = (Select Cd_Pes from Pessoa with(nolock) where num_CPF_CNPJ like @CNPJ)

	Set @Cd_Vendor = (select Cd_Vendor from Pessoa_LLP PL with(nolock)
			  Left Outer Join House_Imp_Mar HOU with(nolock) on HOU.Cd_Export_HIM = PL.Cd_Pes
			  where HOU.Num_Proc_HIM = @Num_Proc)

	Set @ID_NF=(Select iSNULL(max(ID_NF),0)+1 from Nota_Cliente where Cd_cliente = @Cd_Cliente)  

	Begin 
		Insert Into 
			Nota_Cliente
				(
				ID_NF,
				CNPJ,
				Nota_Fiscal,
				Emissao,
				CFOP,
				Invoice,
				Cd_Exportador,
				Vlr_NF,
				CD_Cliente,
				Complementar,
				ID_NF_FK,
				DI,
				Data_DI,
				Paridade,
				Num_Proc
				)
		Values
				(
				@ID_NF,
				@CNPJ,
				@Nota_Fiscal,
				@Emissao,
				@CFOP,
				@Invoice,
				@Cd_Exportador,
				@Vlr_NF,
				@CD_Cliente,
				@Complementar,
				@ID_NF_FK,
				@DI,
				@Data_DI,
				@Paridade,
				@Num_Proc
				)
					
		    Set @ID_NF_N=@ID_NF
		End

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

Commit Transaction 







GO
