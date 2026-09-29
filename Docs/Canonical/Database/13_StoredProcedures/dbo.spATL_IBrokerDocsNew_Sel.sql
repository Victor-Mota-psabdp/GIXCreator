SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_IBrokerDocsNew_Sel]
(
@Num_Proc varchar(16)
)
as

Declare @TDoc table
(
ID_DC int,
GNC varchar(50),
Documento varchar(50),
Status varchar(1)
)
insert @TDoc
select ID_DC,''GNC, Nome_DC [Document],'N' from Tipo_Doc_Cliente with(nolock)
where ID_DC in (2,11,44)  and Doc_Anexo = 'S'

update @TDoc set GNC = 'BDDI004' where ID_DC = 2

update @TDoc set GNC = 'BDDI017' where ID_DC = 11

update @TDoc set GNC = 'BDDI002' where ID_DC = 44

select GNC, Documento [Document],Status from @TDoc

GO
