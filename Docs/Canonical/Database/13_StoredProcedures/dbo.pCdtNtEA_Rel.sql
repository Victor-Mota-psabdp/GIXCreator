SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCdtNtEA_Rel
(
@Num_Proc		VarChar(16),
@Cd_Pes 		VarChar(10),
@CreditNote		VarChar(12)=''
)
 AS
	Declare @To 	VarChar(60) 
	Declare @Endereco 	varchar(100) 
	Declare @Numero	varchar(10) 
	Declare @compl_end	varchar(30)
	Declare @Cep		varchar(10)
	Declare @BAirro		varchar(25) 
	Declare @Cidade	varchar(30) 
	Declare @UF		char(2)
	Declare @Pais 		varchar(30) 


	Set @To = (Select Nome_Raz_Soc From Pessoa Where Cd_Pes = @Cd_pes)
	Select @Endereco = Rua, @Numero = Numero, @Compl_End = Compl_End, @Bairro = Bairro, @Cidade = Cidade, @UF = UF, @Pais = Pais From Endereco Where Cd_Pes = @Cd_Pes and cd_Tp_End = 'COM'


	If @Numero  <> null and @Numero <> '' 
	Set @Endereco = @Endereco + ', ' + @Numero 

	If @compl_end  <> null and @compl_end <> '' 
	Set @Endereco = @Endereco + ' - ' + @compl_end 

	If @Bairro  <> null and @Bairro <> '' 
	Set @Endereco = @Endereco + ' - Bairro: ' + @Bairro 

	If @Cidade  <> null and @Cidade <> '' 
	Set @Endereco = @Endereco + ' - ' + @Cidade 

	If @UF  <> null and @UF <> '' 
	Set @Endereco = @Endereco + '-' + @UF 

	If @Pais  <> null and @Pais <> '' 
	Set @Endereco = @Endereco + '/' + @Pais 


	Select 
		@To as 'RazaoSocial', @Endereco Endereco, @CreditNote as CreditNote, HEA.MAWB_HEA, HEA.HAWB_HEA, HEA.Num_Proc_HEA, 
		Orig.Nome_Local as Origem, Dest.Nome_Local as Destino
	From 
		House_exp_aer as HEA 
		Left outer join Localidade as Orig on HEA.Cd_Org_HEA = Orig.Cd_Local 
		Left  outer Join Localidade as Dest on HEA.Cd_Dst_HEA = Dest.Cd_local
	Where 
		HEA.Num_Proc_HEA = @Num_Proc
GO
