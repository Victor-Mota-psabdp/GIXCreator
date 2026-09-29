SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Ticket#100-122143 -roberta - Douglas Rodrigues e Willians Viola
CREATE procedure [dbo].[spRetificacaoDI_Despachante_Sel]

as

select Nome_Usuario from Usuario where Cd_Usuario in ('raposo','MAX','NI','dar','wv')




GO
