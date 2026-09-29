SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pCdtNtIM_Rel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCdtNtIM_Rel
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

	Select 
		@To as 'RazaoSocial', @Endereco Endereco, @CreditNote as CreditNote, HIM.MAWB_HIM, HIM.HAWB_HIM, HIM.Num_Proc_HIM, 
		Orig.Nome_Local as Origem, Dest.Nome_Local as Destino
	From 
		House_Imp_Mar as HIM 
		Left outer join Localidade as Orig on HIM.Cd_Org_HIM = Orig.Cd_Local 
		Left  outer Join Localidade as Dest on HIM.Cd_Dst_HIM = Dest.Cd_local
	Where 
		HIM.Num_Proc_HIM = @Num_Proc
GO
