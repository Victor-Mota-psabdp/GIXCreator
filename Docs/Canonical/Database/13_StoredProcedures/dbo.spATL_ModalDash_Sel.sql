SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_ModalDash_Sel](
	@Tipo varchar(50)
)
as

select 
 Modal,
 [ATA],
[Data Liberação BL],
[Data Pgto. AFRMM],
[Data Presença Carga] ,
[Data D.I.],
[Data Canal] ,
[Data Desembaraço] ,
[Data Env. Draft NFe],
[Data Entr. Docs Transp.]

from
Modal_Dash
where Tipo = @Tipo

GO
