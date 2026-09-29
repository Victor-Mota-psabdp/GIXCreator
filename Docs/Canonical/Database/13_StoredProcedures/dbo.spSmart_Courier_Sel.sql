SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSmart_Courier_Sel]--'IMOXT201509002BR'
	@Num_proc as varchar(16)
as	

select 
	C.Num_Courier	[AWBNbr],
	P.cd_vendor		[AWBCd],
	C.Dt_Courier	[AWBActArrivalDate]
from courier_processo C with(nolock)
	join Pessoa_LLP P with(nolock) on P.Cd_pes = C.Cd_Pes
where
	Num_Proc = @Num_proc
	and isnull(cd_vendor,'') <> ''
	

GO
