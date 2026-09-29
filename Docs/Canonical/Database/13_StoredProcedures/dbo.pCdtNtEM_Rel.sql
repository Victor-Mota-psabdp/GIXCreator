SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pCdtNtEM_Rel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCdtNtEM_Rel
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
		@To as 'RazaoSocial', @endereco endereco, @CreditNote as CreditNote, HEM.MAWB_HEM, HEM.HAWB_HEM, HEM.Num_Proc_HEM, 
		Orig.Nome_Local as Origem, Dest.Nome_Local as Destino
	From 
		House_exp_mar as HEM 
		left outer join Localidade as Orig on HEM.Cd_Org_HEM = Orig.Cd_Local 
		Left  outer Join Localidade as Dest on Hem.Cd_Dst_HEM = Dest.Cd_local
	Where 
		HEM.Num_Proc_HEM = @Num_Proc
GO
