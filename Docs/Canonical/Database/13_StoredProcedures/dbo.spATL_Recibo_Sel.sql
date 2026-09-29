SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Recibo_Sel]
(	
	@Num_Proc Varchar(16)
	--@ID bigint
)
as
select 
	R.ID,
	P.Apelido		[Creditor],
	Num_Proc		[Job],
	Fatura			[Invoice],
	CONVERT(varchar,Dt_Recibo,103)	[Register Date],
	U.Nome_Usuario	[User],
	Total			[BRL Value]
from Recibo R with(nolock)
	Join Usuario U		with(nolock) on U.Cd_Usuario = R.Cd_Usuario
	Join Pessoa P		with(nolock) on R.Cd_Cred_Dev = P.Cd_Pes
where  
	R.Num_Proc = @Num_Proc
GO
