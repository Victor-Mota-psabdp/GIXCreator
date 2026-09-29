SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spATL_RHPonto_REl(
 @Usuario varchar(50)
)
as
select ID, Nome_Funcionario,Centro_Custo,Pis,U.Nome_Usuario Responsavel from RH_Ponto R with(nolock)
left  join Usuario U with(nolock) on U.Cd_Usuario = R.Responsavel order by ID



GO
