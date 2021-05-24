#include "tagslist.h"
#include "tagging.h"

TagsList::TagsList(QObject *parent)
    : MauiList(parent)
{
}

void TagsList::setList()
{
    emit this->preListChanged();
    
    if (this->m_urls.isEmpty()) {
        this->list = FMH::toModelList(Tagging::getInstance()->getAllTags(this->strict));
        
    } else if(this->m_urls.size() > 1) {
        this->list.clear();
        
    } else {
        this->list.clear();
        this->list = std::accumulate(this->m_urls.constBegin(), this->m_urls.constEnd(), FMH::MODEL_LIST(), [this](FMH::MODEL_LIST &list, const QString &url) {
                list << FMH::toModelList(Tagging::getInstance()->getUrlTags(url, this->strict));
                return list;
    });
    }
    
    emit this->tagsChanged();
    emit this->postListChanged();
}

void TagsList::refresh()
{
    this->setList();
}

bool TagsList::insert(const QString &tag)
{
    if (Tagging::getInstance()->tag(tag.trimmed()))
        return true;

    return false;
}

void TagsList::insertToUrls(const QString &tag)
{
    if (m_urls.isEmpty())
        return;

    for (const auto &url : std::as_const(this->m_urls))
        Tagging::getInstance()->tagUrl(url, tag);

    this->refresh();
}

void TagsList::updateToUrls(const QStringList &tags) //if there is only one url update the tags if there are more than one url then add the new tags
{
    if (this->m_urls.isEmpty())
        return;
    
    if(this->m_urls.size() == 1)
    {
        Tagging::getInstance()->updateUrlTags(this->m_urls.first(), tags);
    }else
    {
        for (const auto &url : std::as_const(this->m_urls))
        {
            for(const auto &tag : tags)
            {
                Tagging::getInstance()->tagUrl(url, tag);
            }
        }
    }

    this->refresh();
}

void TagsList::removeFromUrls(const int &index)
{
    if (index >= this->list.size() || index < 0)
        return;

    if (this->m_urls.isEmpty())
        return;

    const auto tag = this->list[index][FMH::MODEL_KEY::TAG];

    for (const auto &url : std::as_const(m_urls))
    {
        Tagging::getInstance()->removeUrlTag(url, tag);
    }

    this->remove(index);
}

void TagsList::removeFromUrls(const QString &tag)
{
    const auto index = indexOf(FMH::MODEL_KEY::TAG, tag);
    removeFromUrls(index);
}

bool TagsList::remove(const int &index)
{
    if (index >= this->list.size() || index < 0)
        return false;

    emit this->preItemRemoved(index);
    this->list.removeAt(index);
    emit this->tagsChanged();
    emit this->postItemRemoved();

    return true;
}

void TagsList::removeFrom(const int &index, const QString &url)
{
    if (index >= this->list.size() || index < 0)
        return;

    if (Tagging::getInstance()->removeUrlTag(url, this->list[index][FMH::MODEL_KEY::TAG]))
        this->remove(index);
}

void TagsList::erase(const int &index)
{
    Q_UNUSED(index)
}

const FMH::MODEL_LIST &TagsList::items() const
{
    return this->list;
}

bool TagsList::getStrict() const
{
    return this->strict;
}

void TagsList::setStrict(const bool &value)
{
    if (this->strict == value)
        return;

    this->strict = value;
    emit this->strictChanged();
}

QStringList TagsList::getTags() const
{   
    return FMH::modelToList(this->list, FMH::MODEL_KEY::TAG);
}

QStringList TagsList::getUrls() const
{
    return this->m_urls;
}

void TagsList::setUrls(const QStringList &value)
{
    if (this->m_urls == value)
        return;

    this->m_urls = value;
    emit this->urlsChanged();
}

void TagsList::append(const QString &tag)
{
    this->append(FMH::MODEL {{FMH::MODEL_KEY::TAG, tag}});
}

void TagsList::appendItem(const QVariantMap &tag)
{
    this->append(FMH::toModel(tag));
}

void TagsList::append(const FMH::MODEL &tag)
{
    if (this->exists(FMH::MODEL_KEY::TAG, tag[FMH::MODEL_KEY::TAG]))
        return;

    emit this->preItemAppended();
    this->list << tag;
    emit this->postItemAppended();
    emit this->tagsChanged();
}

void TagsList::append(const QStringList &tags)
{
    for (const auto &tag : std::as_const(tags))
    {
        this->append(tag);
    }
}

bool TagsList::contains(const QString &tag)
{
    return this->exists(FMH::MODEL_KEY::TAG, tag);
}

void TagsList::componentComplete()
{
    connect(this, &TagsList::urlsChanged, this, &TagsList::setList);
    connect(this, &TagsList::strictChanged, this, &TagsList::setList);

    //TODO not working idk whyyyyy :(
    connect(Tagging::getInstance(), &Tagging::tagged, this, &TagsList::appendItem);

    connect(Tagging::getInstance(), &Tagging::tagRemoved, this, &TagsList::refresh);
    this->setList();
}
