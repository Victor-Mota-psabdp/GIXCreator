SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spATL_RHPonto_InsUpd
(

	@Nome_Funcionario varchar(50),
	@Centro_Custo varchar(50),
	@Pis varchar(50),
	@Responsavel varchar(50)
)
as

Declare @ID bigint

If not  exists(select Nome_Funcionario from RH_Ponto where Pis = @Pis)
	Begin
		Set @ID = (select max(isnull(ID,0))+1 from RH_Ponto)
		Insert INTO
			RH_Ponto
			(
			ID,
			Nome_Funcionario,
			Centro_Custo,
			Pis,
			Responsavel
			)
			Values
			(
			@ID,
			@Nome_Funcionario,
			@Centro_Custo,
			@Pis,
			@Responsavel
			)
			
	End
else
	Begin
		Update 
				RH_Ponto
			Set 
				Nome_Funcionario = @Nome_Funcionario,
				Centro_Custo = @Centro_Custo,
				Responsavel = @Responsavel
		where
			Pis = @Pis
			
	End


GO
